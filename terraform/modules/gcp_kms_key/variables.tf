variable "project_id" {
  description = "The project id of your GCP project"
  type        = string
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "default_region" {
  type        = string
  description = "Region where resources will be created. "
}

# KMS variables
variable "kms_keyring_id" {
  type        = string
  description = "ID of an existing Cloud KMS KeyRing for asset encryption. Terraform will NOT create this keyring."
}

variable "kms_key_name" {
  type        = string
  description = "KMS key name."
}

variable "kms_key_external_url" {
  type        = string
  description = "External keys that must be created."
  default = null
}

variable "kms_key_algorithm" {
  type        = string
  description = "Algorithm used for key creation."
  default = "GOOGLE_SYMMETRIC_ENCRYPTION"
}

variable "kms_key_protection_level" {
  type        = string
  description = "Protection level used for key creation."
  default = "SOFTWARE"
}

variable "key_iam_permissions" {
  type = map(list(string))
  description = "Map of permissions that must be applied to the key"
}