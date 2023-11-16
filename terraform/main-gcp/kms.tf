# KMS resources
resource "google_kms_key_ring" "keyring" {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  project  = var.gcp_kms_project_id
  name     = "${var.prefix}-keyring"
  location = var.gcp_region
}