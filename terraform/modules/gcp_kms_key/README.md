<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Region where resources will be created. | `string` | n/a | yes |
| <a name="input_key_iam_permissions"></a> [key\_iam\_permissions](#input\_key\_iam\_permissions) | Map of permissions that must be applied to the key | `map(list(string))` | n/a | yes |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | KMS key name. | `string` | n/a | yes |
| <a name="input_kms_keyring_id"></a> [kms\_keyring\_id](#input\_kms\_keyring\_id) | ID of an existing Cloud KMS KeyRing for asset encryption. Terraform will NOT create this keyring. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id of your GCP project | `string` | n/a | yes |
| <a name="input_kms_key_algorithm"></a> [kms\_key\_algorithm](#input\_kms\_key\_algorithm) | Algorithm used for key creation. | `string` | `"GOOGLE_SYMMETRIC_ENCRYPTION"` | no |
| <a name="input_kms_key_external_url"></a> [kms\_key\_external\_url](#input\_kms\_key\_external\_url) | External keys that must be created. | `string` | `null` | no |
| <a name="input_kms_key_protection_level"></a> [kms\_key\_protection\_level](#input\_kms\_key\_protection\_level) | Protection level used for key creation. | `string` | `"SOFTWARE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | n/a |
| <a name="output_key_name"></a> [key\_name](#output\_key\_name) | n/a |
<!-- END_TF_DOCS -->