variable "prefix" {
  description = "prefix used for resource naming."
  type        = string
}

variable "network_ip_range" {
  description = "CIDR range for network"
  type = string
}

variable "kms_db_ip_range" {
  description = "CIDR range for database network"
  type = string
}

variable "ekm_db_ip_range" {
  description = "CIDR range for database network"
  type = string
}

variable "ekm_type" {
  description = "EKM type, can be EXTERNAL OR EXTERNAL_VPC"
  type = string
}

variable "ekm_key_external_url" {
  description = "URL to external ekm key,Required when ekm type is EXTERNAL"
  type = string
  default = null
}

variable "gcp_terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}

variable "gcp_project_id" {
  description = "Project where all resources will be created"
  type        = string
}
variable "gcp_kms_project_id" {
  description = "Project where all resources will keys are managed"
  type        = string
}

variable "gcp_region" {
  description = "Region where all resources will be created"
  type        = string
}
