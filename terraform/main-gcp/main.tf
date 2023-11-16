/******************************************
  Create Database
*****************************************/
resource "random_string" "db_user" {
  length  = 8
  special = false
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

module "kms_pgsql" {
  source = "../modules/gcp_pgsql_ha"

  db_suffix                            = "kms"
  prefix                               = var.prefix
  instance_name                        = "kms"
  project_id                           = var.gcp_project_id
  default_region                       = var.gcp_region
  network_project_id                   = var.gcp_project_id
  network_name                         = module.vpc.network_name
  network_selflink                     = module.vpc.network_self_link
  authorized_networks                  = []
  db_reserved_ip_range                 = var.kms_db_ip_range
  db_tier                              = "db-custom-4-15360"
  db_version                           = "POSTGRES_15"
  enable_deletion_protection           = false
  enable_access_from_nonRFC1918_ranges = false

  root_user_password = random_password.db_password.result
  root_user_username = random_string.db_user.result

  kms_keyring_id           = google_kms_key_ring.keyring.id
  kms_key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
  kms_key_protection_level = "SOFTWARE"
  kms_key_external_url     = null

  labels = {}
}

module "ekm_pgsql" {
  source = "../modules/gcp_pgsql_ha"

  db_suffix                            = "ekm"
  prefix                               = var.prefix
  instance_name                        = "ekm"
  project_id                           = var.gcp_project_id
  kms_project_id                       = var.gcp_kms_project_id
  default_region                       = var.gcp_region
  network_project_id                   = var.gcp_project_id
  network_name                         = module.vpc.network_name
  network_selflink                     = module.vpc.network_self_link
  authorized_networks                  = []
  db_reserved_ip_range                 = var.ekm_db_ip_range
  db_tier                              = "db-custom-4-15360"
  db_version                           = "POSTGRES_15"
  enable_deletion_protection           = false
  enable_access_from_nonRFC1918_ranges = false

  root_user_password = random_password.db_password.result
  root_user_username = random_string.db_user.result

  kms_keyring_id           = google_kms_key_ring.keyring.id
  kms_key_algorithm        = "EXTERNAL_SYMMETRIC_ENCRYPTION"
  kms_key_protection_level = var.ekm_type
  kms_key_external_url     = var.ekm_key_external_url

  enable_psa_vpc_peering = false

  labels = {}
}

/******************************************
  Create Bastion
*****************************************/

module "bastion" {
  source = "../modules/gcp_bastion_host"


  prefix             = var.prefix
  instance_name      = "bastion"
  project_id         = var.gcp_project_id
  authorized_members = []
  region             = var.gcp_region
  network_self_link  = module.vpc.network_self_link
  subnet_self_link   = module.vpc.subnets_self_links[0]

  kms_keyring_id           = google_kms_key_ring.keyring.id
  kms_key_algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
  kms_key_protection_level = "SOFTWARE"
  kms_key_external_url     = null
  db_ekm                   = {
    name     = module.ekm_pgsql.db_name
    host     = module.ekm_pgsql.instance_ip_address
    username = random_string.db_user.result
    password = random_password.db_password.result
  }
  db_kms = {
    name     = module.kms_pgsql.db_name
    host     = module.kms_pgsql.instance_ip_address
    username = random_string.db_user.result
    password = random_password.db_password.result
  }

  labels = {}

  depends_on = [
    module.vpc
  ]
}