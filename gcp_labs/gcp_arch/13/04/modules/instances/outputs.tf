output "instance-name-1" {
  description = "Instance 1 name."
  value       = "module.instances.google_compute_instance.tf-instance-1.name"
}

output "instance-name-2" {
  description = "Instance 2 name."
  value       = "module.instances.google_compute_instance.tf-instance-2.name"
}