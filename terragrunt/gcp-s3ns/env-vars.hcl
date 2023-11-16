locals {
  module_name            = "main-gcp"
  prefix                 = "ekm-perf"
  network_ip_range       = "10.0.0.0/24"
  kms_db_ip_range        = "10.0.1.0/24"
  ekm_db_ip_range        = "10.0.2.0/24"
  gcp_terraform_sa_email = "${ get_env("GCP_IAC_SERVICE_ACCOUNT") }"
  gcp_project_id         = "${ get_env("PROJECT_ID") }"
  gcp_kms_project_id     = "${ get_env("GCP_KMS_PROJECT_ID") }"
  gcp_region             = "${ get_env("GCP_REGION") }"
  ekm_type               = "EXTERNAL_VPC"

}
