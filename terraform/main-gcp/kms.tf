# KMS resources
resource "google_kms_key_ring" "kms_keyring" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  project  = var.gcp_project_id
  name     = "${var.prefix}-kms-keyring"
  location = var.gcp_region
}

resource "google_kms_key_ring" "ekm_keyring" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  project  = var.gcp_ekm_project_id
  name     = "${var.prefix}-ekm-keyring"
  location = var.gcp_region
}