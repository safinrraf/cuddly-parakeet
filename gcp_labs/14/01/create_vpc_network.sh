PROJECT_ID=
REGION=us-west1
VPC_NETWORK_DEV=taw-custom-network

gcloud config set compute/region $REGION

gcloud compute networks create $VPC_NETWORK_DEV \
--project=$PROJECT_ID \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=regional \
--bgp-best-path-selection-mode=legacy

gcloud compute networks subnets create subnet-us-west1 \
--project=$PROJECT_ID \
--range=10.0.0.0/16 \
--stack-type=IPV4_ONLY \
--network=$VPC_NETWORK_DEV \
--region=us-west1

gcloud compute networks subnets create subnet-us-east4 \
--project=$PROJECT_ID \
--range=10.1.0.0/16 \
--stack-type=IPV4_ONLY \
--network=$VPC_NETWORK_DEV \
--region=us-east4

gcloud compute networks subnets create subnet-us-east1 \
--project=$PROJECT_ID \
--range=10.2.0.0/16 \
--stack-type=IPV4_ONLY \
--network=$VPC_NETWORK_DEV \
--region=us-east1

# Create firewall rules
gcloud compute --project=$PROJECT_ID firewall-rules create nw101-allow-http \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=tcp:80 \
--source-ranges=0.0.0.0/0 \
--target-tags=http

gcloud compute --project=$PROJECT_ID firewall-rules create nw101-allow-internal \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=tcp:0-65535,udp:0-65535 \
--source-ranges=10.0.0.0/16,10.1.0.0/16,10.2.0.0/16

gcloud compute --project=$PROJECT_ID firewall-rules create nw101-allow-icmp \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=icmp \
--source-ranges=0.0.0.0/0 \
--target-tags=rules

gcloud compute --project=$PROJECT_ID firewall-rules create nw101-allow-ssh \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=tcp:22 \
--source-ranges=0.0.0.0/0 \
--target-tags=ssh

gcloud compute --project=$PROJECT_ID firewall-rules create nw101-allow-rdp \
--direction=INGRESS \
--priority=1000 \
--network=$VPC_NETWORK_DEV \
--action=ALLOW \
--rules=tcp:3389 \
--source-ranges=0.0.0.0/0