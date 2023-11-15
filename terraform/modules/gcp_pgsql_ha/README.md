<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | Ip ranges authorized to access this database | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | n/a | yes |
| <a name="input_db_reserved_ip_range"></a> [db\_reserved\_ip\_range](#input\_db\_reserved\_ip\_range) | IP range dedicated for database instances. ex: 172.30.0.0/22 | `string` | n/a | yes |
| <a name="input_db_suffix"></a> [db\_suffix](#input\_db\_suffix) | The database suffix to create. | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | The region of the ressources | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Instance name. | `string` | n/a | yes |
| <a name="input_kms_keyring_id"></a> [kms\_keyring\_id](#input\_kms\_keyring\_id) | ID of an existing Cloud KMS KeyRing for asset encryption. Terraform will NOT create this keyring. | `string` | n/a | yes |
| <a name="input_kms_protection_level"></a> [kms\_protection\_level](#input\_kms\_protection\_level) | The protection level to use for the KMS crypto key. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels | `map(string)` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the project network. | `string` | n/a | yes |
| <a name="input_network_project_id"></a> [network\_project\_id](#input\_network\_project\_id) | The project id of the network project. | `string` | n/a | yes |
| <a name="input_network_selflink"></a> [network\_selflink](#input\_network\_selflink) | The selflink of the project network. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A short prefix for all resources names. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id. | `string` | n/a | yes |
| <a name="input_root_user_password"></a> [root\_user\_password](#input\_root\_user\_password) | The password used in cloud sql DB | `string` | n/a | yes |
| <a name="input_root_user_username"></a> [root\_user\_username](#input\_root\_user\_username) | The default user used in cloud sql DB | `string` | n/a | yes |
| <a name="input_db_tier"></a> [db\_tier](#input\_db\_tier) | The tier for gitlab DB instance | `string` | `"db-custom-4-15360"` | no |
| <a name="input_db_version"></a> [db\_version](#input\_db\_version) | The database version for gitlab DB instance | `string` | `"POSTGRES_15"` | no |
| <a name="input_enable_access_from_nonRFC1918_ranges"></a> [enable\_access\_from\_nonRFC1918\_ranges](#input\_enable\_access\_from\_nonRFC1918\_ranges) | Enabled whn non RFC 1918 ranges are used in your VPC. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Whether or not to allow Terraform to destroy the instance | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | Full name of the created database. |
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the master instance to be used in connection strings |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The IPv4 address assigned for the master instance |
<!-- END_TF_DOCS -->