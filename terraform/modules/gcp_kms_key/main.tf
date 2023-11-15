locals {
  is_external_key = startswith(upper(var.kms_key_protection_level), "EXTERNAL")
}
# KMS settings
resource "google_kms_crypto_key" "software_key" {
  count = local.is_external_key ? 0 : 1

  name            = "${var.prefix}-key-${var.default_region}-soft-${var.kms_key_name}"
  key_ring        = var.kms_keyring_id
  rotation_period = "604800s"

  version_template {
    algorithm        = upper(var.kms_key_algorithm)
    protection_level = upper(var.kms_key_protection_level)
  }
}

resource "google_kms_crypto_key" "external_key" {
  count = local.is_external_key ? 1 : 0

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                          = "${var.prefix}-key-${var.default_region}-ext-${var.kms_key_name}"
  key_ring                      = var.kms_keyring_id
  skip_initial_version_creation = true
  version_template {
    algorithm        = upper(var.kms_key_algorithm)
    protection_level = upper(var.kms_key_protection_level)
  }

  lifecycle {
    ignore_changes = [
      skip_initial_version_creation
    ]
  }
}

/******************************************
  Create key version
*****************************************/
resource "null_resource" "external_key_version" {
  count = local.is_external_key ? 1 : 0

  triggers = {
    project_id = var.project_id
    key_name = google_kms_crypto_key.external_key[0].name
    keyring_name  = split("/keyRings/",var.kms_keyring_id)[1]
    kms_external_key_url = var.kms_key_external_url
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
    gcloud --project ${self.triggers.project_id} kms keys versions create --key ${self.triggers.key_name} --keyring ${self.triggers.keyring_name} --location ${var.default_region} --external-key-uri ${self.triggers.kms_external_key_url} --primary
    EOT
  }

  depends_on = [
    google_kms_crypto_key.external_key
  ]
}

/******************************************
  IAM permissions
*****************************************/

resource "google_kms_crypto_key_iam_binding" "key_iam_permission" {
  for_each = var.key_iam_permissions

  crypto_key_id = local.is_external_key ?  google_kms_crypto_key.external_key[0].id : google_kms_crypto_key.software_key[0].id
  role          = each.key

  members = each.value
}