output "instance_ip_address" {
  value       = module.main.instance_first_ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "instance_connection_name" {
  value       = module.main.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "db_name" {
  value       = local.db_name
  description = "Full name of the created database."
}