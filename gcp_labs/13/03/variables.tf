variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-03-0dee30670098"

}

variable "name" {
  description = "Name of the buckets to create."
  type        = string
  default     = "qwiklabs-gcp-03-0dee30670098-storage-bucket"
}