variable "prefix" {
  description = "prefix used for resource naming."
  type        = string
}

variable "network_ip_range" {
  description = "CIDR range for network"
  type = string
}

variable "classic_db_ip_range" {
  description = "CIDR range for database network"
  type = string
}

variable "gcp_terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "gcp_project_id" {
  description = "Project where all resources will be created"
  type        = string
}

variable "gcp_region" {
  description = "Region where all resources will be created"
  type        = string
}
