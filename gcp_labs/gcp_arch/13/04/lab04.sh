# To retrieve your Project ID, run the following command:
gcloud config list --format 'value(core.project)'

# Initialize your backend again, this time to automatically migrate the state
terraform init -migrate-state

#list the contents of the bucket
gsutil ls gs://qwiklabs-gcp-04-82fef5136deb


#Bringing existing infrastructure under Terraform’s control involves five main steps:

# 1.Identify the existing infrastructure to be imported.
# 2.Import the infrastructure into your Terraform state.
# 3.Write a Terraform configuration that matches that infrastructure.
# 4.Review the Terraform plan to ensure that the configuration matches the expected state and infrastructure.
# 5.Apply the configuration to update your Terraform state.


# Create a container named hashicorp-learn using the latest NGINX image from Docker Hub, and preview the container on the Cloud Shell virtual machine over port 80 (HTTP):
docker run --name hashicorp-learn --detach --publish 8080:80 nginx:latest

#Run the following terraform import command to attach the existing Docker container to the docker_container.web 
# resource you just created. Terraform import requires this Terraform resource ID and the full Docker container ID. 
# The command docker inspect -f {{.ID}} hashicorp-learn returns the full SHA256 container ID:
terraform import docker_container.web $(docker inspect -f {{.ID}} hashicorp-learn)

# Copy your Terraform state into your docker.tf file
terraform show -no-color > docker.tf