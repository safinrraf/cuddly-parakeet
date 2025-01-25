resource "google_storage_bucket" "static" {
  name          = "qwiklabs-gcp-00-fe33ff210e81-bucket"
  location      = "us-east4"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
}

resource "google_pubsub_topic" "example" {
  name = "topic-memories-807"
}
