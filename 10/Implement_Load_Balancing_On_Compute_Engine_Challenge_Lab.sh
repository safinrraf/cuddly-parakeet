#
#Implement Load Balancing on Compute Engine: Challenge Lab
#

# Pre-steps

REGION=us-west3
ZONE=us-west3-b
FIREWALL_RULE=grant-tcp-rule-821
INSTANCE_NAME=nucleus-jumphost-660

# Requirements:

# Name the instance Instance name.
# Create the instance in the ZONE zone.
# Use an e2-micro machine type.
# #Use the default image type (Debian Linux).

# 1.1. Set the default region
gcloud config set compute/region $REGION

# 1.2. In Cloud Shell, set the default zone:
gcloud config set compute/zone $ZONE

# 1.3.
gcloud compute instances create $INSTANCE_NAME --tags=network-lb-tag --machine-type=e2-micro

#
#
#

# 2.1 Create an instance template. Don't use the default machine type. Make sure you specify e2-medium as the machine type and create the Global template.
# 2.2 Create a managed instance group based on the template.
# 2.3 Create a firewall rule named as [Firewall rule] to allow traffic (80/tcp).
# 2.4 Create a health check.
# 2.5 Create a backend service and add your instance group as the backend to the backend service group with named port (http:80).
# 2.6 Create a URL map, and target the HTTP proxy to route the incoming requests to the default backend service.
# 2.7 Create a target HTTP proxy to route requests to your URL map
# 2.8 Create a forwarding rule.

# 2.1 Create an instance template.
# gcloud compute instance-templates create facilitates the creation of Compute Engine virtual machine instance templates.
# Instance templates are global resources, and can be used to create instances in any zone.
# cat << EOF > startup.sh
#! /bin/bash
#apt-get update
#apt-get install -y nginx
#service nginx start
#sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
#EOF
#
#

gcloud compute instance-templates create mywebserver-template --project=qwiklabs-gcp-03-43a7bc932947 --machine-type=e2-medium --network-interface=network=default,stack-type=IPV4_ONLY,no-address --metadata=startup-script=\#\!\ /bin/bash$'\n'apt-get\ update$'\n'apt-get\ install\ -y\ nginx$'\n'service\ nginx\ start$'\n'sed\ -i\ --\ \'s/nginx/Google\ Cloud\ Platform\ -\ \'\"\\\$HOSTNAME\"\'/\'\ /var/www/html/index.nginx-debian.html,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=339478190402-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --tags=allow-health-checks --create-disk=auto-delete=yes,boot=yes,device-name=mywebserver-template,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250113,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute instance-templates create lb-backend-template
    --project=qwiklabs-gcp-02-afaf213b0dab
    --machine-type=e2-medium
    --network-interface=network=default,network-tier=PREMIUM,stack-type=IPV4_ONLY
    --metadata=startup-script=\#\!\ /bin/bash$'\n'apt-get\ update$'\n'apt-get\ install\ -y\ nginx$'\n'service\ nginx\ start$'\n'sed\ -i\ --\ \'s/nginx/Google\ Cloud\ Platform\ -\ \'\"\\\$HOSTNAME\"\'/\'\ /var/www/html/index.nginx-debian.html,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=34562836832-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append --tags=allow-health-check,http-server --create-disk=auto-delete=yes,boot=yes,device-name=lb-backend-template,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250113,mode=rw,size=10,type=pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud compute instance-templates create lb-backend-template \
   --region=$REGION \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- "s/nginx/Google Cloud Platform - \$HOSTNAME/" /var/www/html/index.nginx-debian.html'


# 2.2 Create a managed instance group based on the template.
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone=$ZONE

# 2.3 Create a firewall rule named as [Firewall rule] to allow traffic (80/tcp).
gcloud compute firewall-rules create $FIREWALL_RULE \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

#generated
gcloud compute --project=qwiklabs-gcp-03-43a7bc932947 firewall-rules create fw-allow-health-checks --description=fw-allow-health-checks --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=130.211.0.0/22,35.191.0.0/16 --target-tags=allow-health-checks

# Now that the instances are up and running, set up a global static external IP address
# that your customers use to reach your load balancer:
gcloud compute addresses create lb-ipv4-1 --ip-version=IPV4 --global

# Note the IPv4 address that was reserved:
gcloud compute addresses describe lb-ipv4-1 --format="get(address)" --global

# 2.4 Create a health check.
gcloud compute health-checks create http http-basic-check --port 80

# 2.5 Create a backend service and add your instance group as the backend to the backend service group with named port (http:80).
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global

# Add your instance group as the backend to the backend service
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global

# 2.6 Create a URL map, and target the HTTP proxy to route the incoming requests to the default backend service.
gcloud compute url-maps create web-map-http --default-service web-backend-service

# Create a target HTTP proxy to route requests to your URL map
gcloud compute target-http-proxies create http-lb-proxy --url-map web-map-http

# 2.8 Create a forwarding rule.
gcloud compute forwarding-rules create http-content-rule \
   --address=lb-ipv4-1\
   --global \
   --target-http-proxy=http-lb-proxy \
   --ports=80
