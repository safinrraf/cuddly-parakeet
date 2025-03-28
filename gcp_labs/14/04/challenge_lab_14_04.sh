gcloud config set compute/zone "us-central1-c"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-central1"
export REGION=$(gcloud config get compute/region)

PROJECT_ID=qwiklabs-gcp-01-888713c21e9d
VPC_NETWORK_DEV=vpc-network-v3om
SUBNET_1=subnet-a-euw6
SUBNET_2=subnet-b-kdom
REGION_1=us-central1
REGION_2=europe-west1
FIREWALL_RULE_1=aoug-firewall-ssh
FIREWALL_RULE_2=urdm-firewall-rdp
FIREWALL_RULE_3=wdhu-firewall-icmp
ZONE1=us-central1-c
ZONE2=europe-west1-b

#Create a custom VPC network
gcloud compute networks create $VPC_NETWORK_DEV \
--project=$PROJECT_ID \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=regional \
--bgp-best-path-selection-mode=legacy

#Create subnets
gcloud compute networks subnets create $SUBNET_1 \
--project=$PROJECT_ID \
--network=$VPC_NETWORK_DEV \
--region=$REGION_1 \
--range=10.10.10.0/24 \
--stack-type=IPV4_ONLY 

gcloud compute networks subnets create $SUBNET_2 \
--project=$PROJECT_ID \
--network=$VPC_NETWORK_DEV \
--region=$REGION_2 \
--range=10.10.20.0/24 \
--stack-type=IPV4_ONLY 

#Create  firewall rules
gcloud compute --project=$PROJECT_ID firewall-rules create $FIREWALL_RULE_1 \
--direction=INGRESS \
--priority=1000 \
--action=ALLOW \
--rules=tcp:22 \
--network=$VPC_NETWORK_DEV \
--source-ranges=0.0.0.0/0 

gcloud compute --project=$PROJECT_ID firewall-rules create $FIREWALL_RULE_2 \
--direction=INGRESS \
--priority=65535 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=tcp:3389 \
--source-ranges=0.0.0.0/24

gcloud compute --project=$PROJECT_ID firewall-rules create $FIREWALL_RULE_3 \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=icmp \
--source-ranges=10.10.10.0/24,10.10.20.0/24


gcloud compute instances create us-test-01 \
--subnet $SUBNET_1 \
--zone $ZONE1 \
--machine-type e2-micro

gcloud compute instances create us-test-02 \
--subnet $SUBNET_2 \
--zone $ZONE2 \
--machine-type e2-micro