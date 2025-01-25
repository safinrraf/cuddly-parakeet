#create a new instance with gcloud
gcloud compute instances create gcelab2 --machine-type e2-medium --zone=$ZONE

#To see all the defaults, run the following command:
gcloud compute instances create --help

#You can also use SSH to connect to your instance via gcloud.
#Make sure to add your zone, or omit the --zone flag if you've set the option globally
gcloud compute ssh gcelab2 --zone=us-central1-a

#Create a virtual machine, www1, in your default zone using the following code:
gcloud compute instances create www1 \
  --zone=us-east4-a \
  --tags=network-lb-tag \
  --machine-type=e2-small \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install apache2 -y
    service apache2 restart
    echo "<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'


gcloud compute instances create www2 \
      --zone=us-east4-a \
      --tags=network-lb-tag \
      --machine-type=e2-small \
      --image-family=debian-11 \
      --image-project=debian-cloud \
      --metadata=startup-script='#!/bin/bash
        apt-get update
        apt-get install apache2 -y
        service apache2 restart
        echo "<h3>Web Server: www2</h3>" | tee /var/www/html/index.html'

gcloud compute instances create www3 \
          --zone=us-east4-a  \
          --tags=network-lb-tag \
          --machine-type=e2-small \
          --image-family=debian-11 \
          --image-project=debian-cloud \
          --metadata=startup-script='#!/bin/bash
            apt-get update
            apt-get install apache2 -y
            service apache2 restart
            echo "<h3>Web Server: www3</h3>" | tee /var/www/html/index.html'

#Create a firewall rule to allow external traffic to the VM instances:
gcloud compute firewall-rules create www-firewall-network-lb --target-tags network-lb-tag --allow tcp:80

#Create a static external IP address for your load balancer:
gcloud compute addresses create network-lb-ip-1 --region us-east4

#Add a legacy HTTP health check resource:
gcloud compute http-health-checks create basic-check

#create the load balancer template
gcloud compute instance-templates create lb-backend-template \
   --region=us-east4 \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'

#Create a managed instance group based on the template
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone=us-east4-a

#Create the fw-allow-health-check firewall rule
gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

#Create a health check for the load balancer:
gcloud compute health-checks create http http-basic-check --port 80

#Create a target HTTP proxy to route requests to your URL map:
gcloud compute target-http-proxies create http-lb-proxy --url-map web-map-http

#Create a global forwarding rule to route incoming requests to the proxy:
gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1\
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80
