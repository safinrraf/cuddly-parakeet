provider "google" {
  credentials = file("keys/booming-triode-443711-d1-08974bf8b39c.json")
  project     = "booming-triode-443711-d1"
  region      = "europe-west3"
}

resource "google_bigtable_instance" "my_instance" {
  name         = "my-bigtable-instance"
  cluster {
    cluster_id   = "my-cluster"
    zone         = "europe-west3-a"
    num_nodes    = 1
    storage_type = "SSD"
  }
}

resource "google_bigtable_table" "my_table" {
  name           = "colors_table"
  instance_name  = google_bigtable_instance.my_instance.name
  column_family {
    family = "metadata"
  }
}
