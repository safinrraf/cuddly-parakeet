terraform {
  backend "gcs" {
    bucket  = "tf-bucket-917269"
    prefix  = "terraform/state"
  }
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
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

module "vpc" {
    source  = "terraform-google-modules/network/google"

    project_id   = var.project_id
    network_name = "tf-vpc-490305"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
        }
    ]
}

resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = "tf-vpc-490305"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]  # Allow traffic from all IPs
  direction     = "INGRESS"
  priority      = 1000  # Default priority
}
