PROJECT_ID=qwiklabs-gcp-04-521e79a37376
VPC_NETWORK_DEV=taw-custom-network

gcloud config set compute/zone "us-central1-f"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-central1"
export REGION=$(gcloud config get compute/region)

#Create a custom VPC network
gcloud compute networks create $VPC_NETWORK_DEV --subnet-mode custom

#Create subnets
gcloud compute networks subnets create subnet-us-central1 \
   --network taw-custom-network \
   --region  "us-central1" \
   --range 10.0.0.0/16

gcloud compute networks subnets create subnet-us-east1 \
   --network taw-custom-network \
   --region  "us-east1"\
   --range 10.1.0.0/16

gcloud compute networks subnets create subnet-us-west1 \
   --network $VPC_NETWORK_DEV \
   --region  "us-west1"\
   --range 10.2.0.0/16

#List your networks:
gcloud compute networks subnets list --network $VPC_NETWORK_DEV

#Create additional firewall rules
#HTTP
gcloud compute firewall-rules create nw101-allow-http \
--allow tcp:80 \
--network $VPC_NETWORK_DEV \
--source-ranges 0.0.0.0/0 \
--target-tags http

#ICMP
gcloud compute firewall-rules create "nw101-allow-icmp" \
--allow icmp \
--network $VPC_NETWORK_DEV \
--target-tags rules

#Internal Communication
gcloud compute firewall-rules create "nw101-allow-internal" \
--allow tcp:0-65535,udp:0-65535,icmp \
--network $VPC_NETWORK_DEV \
--source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"

#SSH
gcloud compute firewall-rules create "nw101-allow-ssh" \
--allow tcp:22 \
--network $VPC_NETWORK_DEV \
--target-tags "ssh"

#RDP
gcloud compute firewall-rules create "nw101-allow-rdp" \
--allow tcp:3389 \
--network $VPC_NETWORK_DEV