provider "google" {
  project     = "qwiklabs-gcp-04-82fef5136deb"
  region      = "us-east1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "qwiklabs-gcp-04-82fef5136deb"
  location    = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}

#terraform {
#  backend "gcs" {
#    bucket  = "qwiklabs-gcp-04-82fef5136deb"
#    prefix  = "terraform/state"
#  }
#}

terraform {
  backend "local" {
    path = "terraform/state/terraform.tfstate"
  }
}