# to create an Artifact Registry repository named devops-repo
gcloud artifacts repositories create devops-repo --repository-format=docker --location=us-central1

# to configure Docker to authenticate to the Artifact Registry Docker repository, enter the following command
gcloud auth configure-docker us-central1-docker.pkg.dev

# to use Cloud Build to create the image and store it in Artifact Registry
gcloud builds submit --tag us-central1-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-repo/devops-image:v0.1 .
