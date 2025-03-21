REGION=us-east1
ZONE=us-east1-d
VPC_NETWORK_DEV=griffin-dev-vpc
VPC_NETWORK_PROD=griffin-prod-vpc
VPC_NETWORK_DEV_FIREWALL_TCP_UDP_ICMP=griffin-dev-vpc-firewall-tcp-udp-icmp
VPC_NETWORK_DEV_FIREWALL_TCP22_TCP3389=griffin-dev-vpc-firewall-tcp22-tcp3389
VPC_NETWORK_PROD_FIREWALL_TCP_UDP_ICMP=griffin-prod-vpc-firewall-tcp-udp-icmp
VPC_NETWORK_PROD_FIREWALL_TCP22_TCP3389=griffin-prod-vpc-firewall-tcp22-tcp3389
BASTION_INSTANCE_NAME=griffin-bastion-host


gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

#Task 1. Create development VPC manually
#OK
gcloud compute networks create $VPC_NETWORK_DEV --subnet-mode=custom --bgp-routing-mode=regional

gcloud compute networks subnets create griffin-dev-wp \
--network=$VPC_NETWORK_DEV \
--region=$REGION \
--range=192.168.16.0/20

gcloud compute networks subnets create griffin-dev-mgmt \
--network=$VPC_NETWORK_DEV \
--region=$REGION \
--range=192.168.32.0/20

#In Cloud Shell, run the following command to create the privatenet-allow-icmp-ssh-rdp firewall rule:
gcloud compute firewall-rules create $VPC_NETWORK_DEV_FIREWALL_TCP22_TCP3389 \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=icmp,tcp:22,tcp:3389 \
--source-ranges=0.0.0.0/0

gcloud compute firewall-rules create $VPC_NETWORK_DEV_FIREWALL_TCP_UDP_ICMP --network $VPC_NETWORK_DEV --allow tcp,udp,icmp --source-ranges 0.0.0.0/0

#Task 2. Create production VPC manually
#OK
gcloud compute networks create $VPC_NETWORK_PROD --subnet-mode=custom --bgp-routing-mode=regional

gcloud compute networks subnets create griffin-prod-wp \
--network=$VPC_NETWORK_PROD \
--region=$REGION \
--range=192.168.48.0/20

gcloud compute networks subnets create griffin-prod-mgmt \
--network=$VPC_NETWORK_PROD \
--region=$REGION \
--range=192.168.64.0/20

#Instances on this network will not be reachable until firewall rules
#are created. As an example, you can allow all internal traffic between
#instances as well as SSH, RDP, and ICMP by running:

gcloud compute firewall-rules create $VPC_NETWORK_PROD_FIREWALL_TCP22_TCP3389 \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_PROD \
--action=ALLOW \
--rules=icmp,tcp:22,tcp:3389 \
--source-ranges=0.0.0.0/0

gcloud compute firewall-rules create $VPC_NETWORK_PROD_FIREWALL_TCP_UDP_ICMP --network $VPC_NETWORK_PROD --allow tcp,udp,icmp --source-ranges 0.0.0.0/0

#Task 3. Create bastion host
gcloud compute instances create $BASTION_INSTANCE_NAME \
--machine-type=e2-medium \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=griffin-dev-mgmt \
--network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=griffin-prod-mgmt 

#Task 4. MySQL

gcloud sql connect griffin-dev-db --user=root --quiet

#Task 5. Create Kubernetes cluster
gcloud container clusters create griffin-dev \
    --num-nodes=2 \
    --machine-type=e2-standard-4 \
    --zone=$ZONE \
    --network=griffin-dev-vpc \
    --subnetwork=griffin-dev-wp

#Task 6. Prepare the Kubernetes cluster
mkdir wp-k8s
gsutil -m cp -r gs://cloud-training/gsp321/wp-k8s .