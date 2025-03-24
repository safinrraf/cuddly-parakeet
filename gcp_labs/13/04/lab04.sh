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