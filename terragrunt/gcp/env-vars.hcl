locals {
  module_name              = "main-gcp"
  gcp_terraform_sa_email   = "${ get_env("GCP_IAC_SERVICE_ACCOUNT") }"
}
