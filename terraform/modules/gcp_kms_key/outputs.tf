output "key_id" {
  value = local.is_external_key ?   google_kms_crypto_key.external_key[0].id : google_kms_crypto_key.software_key[0].id
}

output "key_name" {
  value = local.is_external_key ?  google_kms_crypto_key.external_key[0].name : google_kms_crypto_key.software_key[0].name
}