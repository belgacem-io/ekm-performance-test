variable "project_id" {
  description = "The project id."
  type        = string
}

variable "prefix" {
  type        = string
  description = "A short prefix for all resources names."
}

variable "instance_name" {
  type        = string
  description = "Instance name."
}

variable "network_selflink" {
  type        = string
  description = "The selflink of the project network."
}

variable "network_name" {
  type        = string
  description = "The name of the project network."
}

variable "network_project_id" {
  type        = string
  description = "The project id of the network project."
}

variable "default_region" {
  type        = string
  description = "The region of the ressources"
}

#DATABASE
variable "db_reserved_ip_range" {
  type        = string
  description = "IP range dedicated for database instances. ex: 172.30.0.0/22"
}

variable "db_tier" {
  type        = string
  description = "The tier for gitlab DB instance"
  default     = "db-custom-4-15360"
}

variable "db_version" {
  type        = string
  description = "The database version for gitlab DB instance"
  default     = "POSTGRES_15"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the instance"
  default     = true
}

variable "root_user_username" {
  type        = string
  description = "The default user used in cloud sql DB"
}

variable "root_user_password" {
  type        = string
  description = "The password used in cloud sql DB"
}

variable "authorized_networks" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Ip ranges authorized to access this database"
}

variable "db_suffix" {
  type        = string
  description = "The database suffix to create."
}

variable "labels" {
  type        = map(string)
  description = "Map of labels"
}

variable "enable_access_from_nonRFC1918_ranges" {
  default     = false
  type        = bool
  description = "Enabled whn non RFC 1918 ranges are used in your VPC."
}


# KMS variables
variable "kms_keyring_id" {
  type        = string
  description = "ID of an existing Cloud KMS KeyRing for asset encryption. Terraform will NOT create this keyring."
}

variable "kms_key_protection_level" {
  type        = string
  description = "The protection level to use for the KMS crypto key."
}

variable "kms_key_algorithm" {
  type        = string
  description = "The algorithm to use for the KMS crypto key."
}
variable "kms_key_external_url" {
  type        = string
  description = "The external url to use for the KMS crypto key."
  default = null
}

variable "enable_psa_vpc_peering" {
  type = bool
  default = true
  description = "If PSA must be enabled."
}