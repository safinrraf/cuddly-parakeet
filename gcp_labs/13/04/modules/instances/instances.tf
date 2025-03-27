# module.instances.google_compute_instance.tf-instance-1:
resource "google_compute_instance" "tf-instance-1" {
    machine_type            = var.machine_type
    name                    = "tf-instance-1"
    project                 = var.project_id
    zone                    = var.zone

    boot_disk {
        auto_delete = true
        mode        = "READ_WRITE"

        initialize_params {
            image  = var.machine_image
        }
    }

    network_interface {
        network            = var.machine_network
        #subnetwork         = "subnet-01"

        access_config {
        // Ephemeral public IP
        }
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}

# module.instances.google_compute_instance.tf-instance-2:
resource "google_compute_instance" "tf-instance-2" {
    machine_type            = var.machine_type
    name                    = "tf-instance-2"
    project                 = var.project_id
    zone                    = var.zone

    boot_disk {
        auto_delete = true
        mode        = "READ_WRITE"

        initialize_params {
            image  = var.machine_image
        }
    }

    network_interface {
        network            = var.machine_network
        #subnetwork         = "subnet-02"

        access_config {
        // Ephemeral public IP
        }
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}


resource "google_compute_instance" "tf-instance-292823" {
  name         = "tf-instance-292823"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }

  network_interface {
    network = var.machine_network

    access_config {
      // Ephemeral public IP
    }
  }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}