<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_members"></a> [authorized\_members](#input\_authorized\_members) | List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email} | `list(string)` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the VM instance to create and allow SSH from IAP. | `string` | n/a | yes |
| <a name="input_kms_key_algorithm"></a> [kms\_key\_algorithm](#input\_kms\_key\_algorithm) | The algorithm to use for the KMS crypto key. | `string` | n/a | yes |
| <a name="input_kms_key_protection_level"></a> [kms\_key\_protection\_level](#input\_kms\_key\_protection\_level) | The protection level to use for the KMS crypto key. | `string` | n/a | yes |
| <a name="input_kms_keyring_id"></a> [kms\_keyring\_id](#input\_kms\_keyring\_id) | ID of an existing Cloud KMS KeyRing for asset encryption. Terraform will NOT create this keyring. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Map of labels | `map(string)` | n/a | yes |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | Network where to install the bastion host | `string` | n/a | yes |
| <a name="input_no_proxy_hosts"></a> [no\_proxy\_hosts](#input\_no\_proxy\_hosts) | The company's private DNS domains | `list(string)` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service to all resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where to set up the instance and IAP tunneling | `string` | n/a | yes |
| <a name="input_proxy_host_address"></a> [proxy\_host\_address](#input\_proxy\_host\_address) | The company's Proxy IP address | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to create the subnet and VM. | `string` | n/a | yes |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | Subnet where to install the bastion host | `string` | n/a | yes |
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Creates an autoscaler for the managed instance group | `bool` | `false` | no |
| <a name="input_autoscaling_lb"></a> [autoscaling\_lb](#input\_autoscaling\_lb) | Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization | `list(map(number))` | `[]` | no |
| <a name="input_autoscaling_metric"></a> [autoscaling\_metric](#input\_autoscaling\_metric) | Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric | <pre>list(object({<br>    name   = string<br>    target = number<br>    type   = string<br>  }))</pre> | `[]` | no |
| <a name="input_autoscaling_scale_in_control"></a> [autoscaling\_scale\_in\_control](#input\_autoscaling\_scale\_in\_control) | Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control | <pre>object({<br>    fixed_replicas   = number<br>    percent_replicas = number<br>    time_window_sec  = number<br>  })</pre> | <pre>{<br>  "fixed_replicas": 0,<br>  "percent_replicas": 30,<br>  "time_window_sec": 600<br>}</pre> | no |
| <a name="input_cooldown_period"></a> [cooldown\_period](#input\_cooldown\_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. | `number` | `60` | no |
| <a name="input_instance_image"></a> [instance\_image](#input\_instance\_image) | The instance image. Must be debian base. | `string` | `"rocky-linux-cloud/rocky-linux-9-optimized-gcp"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the VM instance to create and allow SSH from IAP. | `string` | `"e2-medium"` | no |
| <a name="input_kms_key_external_url"></a> [kms\_key\_external\_url](#input\_kms\_key\_external\_url) | The external url to use for the KMS crypto key. | `string` | `null` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas. | `number` | `1` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0. | `number` | `1` | no |
| <a name="input_proxy_host_port"></a> [proxy\_host\_port](#input\_proxy\_host\_port) | The company's Proxy port | `string` | `"3128"` | no |
| <a name="input_update_policy"></a> [update\_policy](#input\_update\_policy) | The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy | <pre>list(object({<br>    max_surge_fixed              = number<br>    instance_redistribution_type = string<br>    max_surge_percent            = number<br>    max_unavailable_fixed        = number<br>    max_unavailable_percent      = number<br>    min_ready_sec                = number<br>    replacement_method           = string<br>    minimal_action               = string<br>    type                         = string<br>  }))</pre> | <pre>[<br>  {<br>    "instance_redistribution_type": "PROACTIVE",<br>    "max_surge_fixed": 0,<br>    "max_surge_percent": null,<br>    "max_unavailable_fixed": 4,<br>    "max_unavailable_percent": null,<br>    "min_ready_sec": 180,<br>    "minimal_action": "REPLACE",<br>    "replacement_method": "RECREATE",<br>    "type": "PROACTIVE"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->