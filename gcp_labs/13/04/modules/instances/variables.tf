variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-00-cc845cd6e714"
}

variable "region" {
  description = "The region of the project."
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "The region of the project."
  type        = string
  default     = "us-west1-a"
}

variable "machine_type" {
  description = "The type of machine to use for the instance."
  type        = string
  default     = "e2-standard-2"
}

variable "machine_image" {
    description = "The image to use for the instance."
    type        = string
    default     = "debian-cloud/debian-11-bullseye-v20250311"
}

variable "machine_network" {
    description = "The network to use for the instance."
    type        = string
    default     = "tf-vpc-057610"
}