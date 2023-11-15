variable "prefix" {
  type        = string
  description = "Prefix applied to service to all resources."
}

variable "authorized_members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
}

variable "project_id" {
  type        = string
  description = "Project ID where to set up the instance and IAP tunneling"
}

variable "instance_name" {
  type        = string
  description = "Name of the VM instance to create and allow SSH from IAP."
}

variable "instance_type" {
  type        = string
  description = "Type of the VM instance to create and allow SSH from IAP."
  default     = "e2-medium" #"n1-standard-1"
}

variable "region" {
  type        = string
  description = "Region to create the subnet and VM."
}

variable "network_self_link" {
  type        = string
  description = "Network where to install the bastion host"
}

variable "subnet_self_link" {
  type        = string
  description = "Subnet where to install the bastion host"
}

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  type        = number
  default     = 1
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  type        = number
  default     = 1
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  type        = number
  default     = 60
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_metric" {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric"
  type        = list(object({
    name   = string
    target = number
    type   = string
  }))
  default = []
}

variable "autoscaling_lb" {
  description = "Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_scale_in_control" {
  description = "Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control"
  type        = object({
    fixed_replicas   = number
    percent_replicas = number
    time_window_sec  = number
  })
  default = {
    fixed_replicas   = 0
    percent_replicas = 30
    time_window_sec  = 600
  }
}

variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  type        = bool
  default     = false
}

variable "labels" {
  type        = map(string)
  description = "Map of labels"
}

variable "update_policy" {
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_surge_percent            = number
    max_unavailable_fixed        = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    replacement_method           = string
    minimal_action               = string
    type                         = string
  }))
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy"
  default     = [
    {
      max_surge_fixed              = 0
      max_surge_percent            = null
      instance_redistribution_type = "PROACTIVE"
      max_unavailable_fixed        = 4
      max_unavailable_percent      = null
      min_ready_sec                = 180
      minimal_action               = "REPLACE"
      type                         = "PROACTIVE"
      replacement_method           = "RECREATE"
    }
  ]
}

variable "instance_image" {
  description = "The instance image. Must be debian base."
  type        = string
  default     = "rocky-linux-cloud/rocky-linux-9-optimized-gcp"
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
  default     = null
}

variable "db_kms" {
  type = object({
    name     = string
    host     = string
    username = string
    password = string
  })
}

variable "db_ekm" {
  type = object({
    name     = string
    host     = string
    username = string
    password = string
  })
}