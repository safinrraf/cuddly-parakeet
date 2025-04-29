resource "google_storage_bucket" "storage-bucket" {
  name               = var.bucket-name
  project            = var.project_id
  location           = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}