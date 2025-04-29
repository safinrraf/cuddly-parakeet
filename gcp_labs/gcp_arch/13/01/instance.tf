resource "google_compute_instance" "terraform" {
  project      = "qwiklabs-gcp-01-2cb332779a06"
  name         = "terraform"
  machine_type = "e2-medium"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}