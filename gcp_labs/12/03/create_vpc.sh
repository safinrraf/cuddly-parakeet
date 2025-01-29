# --subnet-mode=custom
# Auto mode networks create subnets in each region automatically,
# while custom mode networks start with no subnets, giving you full control over subnet creation
gcloud compute networks create managementnet \
--project=qwiklabs-gcp-02-9530d43788dc \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=regional \
--bgp-best-path-selection-mode=legacy

gcloud compute networks subnets create managementsubnet-1 \
--project=qwiklabs-gcp-02-9530d43788dc \
--range=10.130.0.0/20 \
--stack-type=IPV4_ONLY \
--network=managementnet \
--region=us-east1

gcloud compute networks create privatenet \
--project=qwiklabs-gcp-02-9530d43788dc \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=regional \
--bgp-best-path-selection-mode=legacy

gcloud compute networks subnets create privatesubnet-1 \
--network=privatenet \
--region=us-east1 \
--range=172.16.0.0/24

gcloud compute networks subnets create privatesubnet-2 \
--network=privatenet \
--region=asia-southeast1 \
--range=172.20.0.0/20

 #Run the following command to list the available VPC networks:
gcloud compute networks list

#Run the following command to list the available VPC subnets (sorted by VPC network):
gcloud compute networks subnets list --sort-by=NETWORK

# Create the firewall rules for managementnet
gcloud compute --project=qwiklabs-gcp-02-9530d43788dc firewall-rules create managementnet-allow-icmp-ssh-rdp \
--direction=INGRESS \
--priority=1000 \
--network=managementnet \
--action=ALLOW \
--rules=tcp:22,tcp:3389 \
--source-ranges=0.0.0.0/0

#In Cloud Shell, run the following command to create the privatenet-allow-icmp-ssh-rdp firewall rule:
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp \
--direction=INGRESS \
--priority=1000 \
--network=privatenet \
--action=ALLOW \
--rules=icmp,tcp:22,tcp:3389 \
--source-ranges=0.0.0.0/0

# Run the following command to list all the firewall rules (sorted by VPC network):
gcloud compute firewall-rules list --sort-by=NETWORK

#Create the managementnet-vm-1 instance
gcloud compute instances create managementnet-vm-1 \
    --project=qwiklabs-gcp-02-9530d43788dc \
    --zone=us-east1-c \
    --machine-type=e2-micro \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=managementsubnet-1 \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=859347128234-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=managementnet-vm-1,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250113,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

# Create the privatenet-vm-1 instance
gcloud compute instances create privatenet-vm-1 --zone=us-east1-c --machine-type=e2-micro --subnet=privatesubnet-1

# Run the following command to list all the VM instances (sorted by zone):
gcloud compute instances list --sort-by=ZONE

#Create the VM instance with multiple network interfaces
