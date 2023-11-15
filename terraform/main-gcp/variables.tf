########################################################
#                   GCP organization config
########################################################
variable "gcp_terraform_sa_email" {
  description = "Service account email of the account to impersonate to run Terraform."
  type        = string
}
