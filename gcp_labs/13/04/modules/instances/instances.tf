# module.instances.google_compute_instance.tf-instance-1:
resource "google_compute_instance" "tf-instance-1" {
    machine_type            = "e2-micro"
    name                    = "tf-instance-1"
    project                 = var.project_id
    zone                    = var.zone

    boot_disk {
        auto_delete = true
        mode        = "READ_WRITE"

        initialize_params {
            image  = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20250311"
            labels = {}
            size   = 10
            type   = "pd-standard"
        }
    }

    network_interface {
        network            = "default"
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}

# module.instances.google_compute_instance.tf-instance-2:
resource "google_compute_instance" "tf-instance-2" {
    machine_type            = "e2-micro"
    name                    = "tf-instance-2"
    project                 = var.project_id
    zone                    = var.zone

    boot_disk {
        auto_delete = true
        mode        = "READ_WRITE"

        initialize_params {
            image  = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20250311"
            labels = {}
            size   = 10
            type   = "pd-standard"
        }
    }

    network_interface {
        network            = "default"
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}
