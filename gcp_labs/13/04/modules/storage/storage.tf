resource "google_storage_bucket" "tf-bucket-804308" {
  name               = var.bucket-name
  project            = var.project_id
  location           = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}