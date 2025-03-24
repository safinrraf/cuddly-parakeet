#!/bin/bash

# Task 1. Create the configuration files

export REGION=us-east1
export ZONE=us-east1-d
export PROJECT_ID=qwiklabs-gcp-00-6a15b1d791c9

REGION=us-east1
ZONE=us-east1-d
PROJECT_ID=qwiklabs-gcp-00-6a15b1d791c9
STORAGE_BUCKET=tf-bucket-804308

touch main.tf
cat <<EOF > main.tf
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "instances" {
  source = "./modules/instances"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

module "storage" {
  source = "./modules/storage"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
EOF
touch variables.tf
cat <<EOF > variables.tf
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "$PROJECT_ID"
}

variable "region" {
  description = "The region of the project."
  type        = string
  default     = "$REGION"
}

variable "zone" {
  description = "The region of the project."
  type        = string
  default     = "$ZONE"
}
EOF
mkdir modules
cd modules
mkdir instances
cd instances
touch instances.tf
touch outputs.tf
cp ../../variables.tf .
cd ../
mkdir storage
cd storage
touch storage.tf
touch outputs.tf
touch variables.tf
cat <<EOF > variables.tf
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "$PROJECT_ID"
}

variable "region" {
  description = "The region of the project."
  type        = string
  default     = "$REGION"
}

variable "zone" {
  description = "The region of the project."
  type        = string
  default     = "$ZONE"
}

variable "bucket-name" {
  description = "The name of the bucket."
  type        = string
  default     = "$STORAGE_BUCKET"
}
EOF
cd ../../
pwd


# Task 2. Import infrastructure
terraform import module.instances.google_compute_instance.tf-instance-1 $PROJECT_ID/$ZONE/tf-instance-1

terraform import module.instances.google_compute_instance.tf-instance-2 $PROJECT_ID/$ZONE/tf-instance-2

terraform show -no-color > modules/instances/instances.tf