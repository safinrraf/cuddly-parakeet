gcloud config set compute/zone "us-central1-c"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-central1"
export REGION=$(gcloud config get compute/region)

#Create an instance named us-test-01 in the us-central1-c zone
gcloud compute instances create us-test-01 \
--subnet subnet-us-central1 \
--zone us-central1-c \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-02 \
--subnet subnet-us-east1 \
--zone us-east1-d \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-03 \
--subnet subnet-us-east4 \
--zone us-east4-a \
--machine-type e2-standard-2 \
--tags ssh,http,rules

gcloud compute instances create us-test-04 \
--subnet subnet-us-central1 \
--zone us-central1-c \
--tags ssh,http