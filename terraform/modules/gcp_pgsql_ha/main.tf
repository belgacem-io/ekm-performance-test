locals {
  #[prefix]-[resource]-[location]-[description]-[suffix]
  db_name = "${var.prefix}-db-${var.default_region}-${var.db_suffix}"

}

resource "google_compute_global_address" "reserved_ip_range" {
  provider = google-beta

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name = "${var.prefix}-gip-glb-pgsql-${var.instance_name}"

  project       = var.network_project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = var.network_selflink
  address       = split( "/", var.db_reserved_ip_range)[0]
  prefix_length = split( "/", var.db_reserved_ip_range)[1]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = var.network_selflink
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.reserved_ip_range.name
  ]
}

resource "google_compute_network_peering_routes_config" "psa_routes" {

  project              = var.network_project_id
  peering              = google_service_networking_connection.private_vpc_connection.peering
  network              = var.network_name
  export_custom_routes = true
  import_custom_routes = true
}

module "peering_non_rfc1918" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.3"

  enabled               = var.enable_access_from_nonRFC1918_ranges
  platform              = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body       = join(" ", [
    "compute networks peerings",
    "update",
    replace(google_service_networking_connection.private_vpc_connection.service, ".", "-"),
    "--project=${var.network_project_id} --network=${var.network_name}",
    "--export-subnet-routes-with-public-ip --import-subnet-routes-with-public-ip"
  ])

  depends_on = [
    google_compute_network_peering_routes_config.psa_routes
  ]
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key" "db_encryption_key" {

  name            = "${var.prefix}-key-${var.default_region}-${var.instance_name}-pgsql"
  key_ring        = var.kms_keyring_id
  rotation_period = "604800s"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = upper(var.kms_protection_level)
  }
}

resource "google_kms_crypto_key_iam_binding" "db_encryption_iam" {
  crypto_key_id = google_kms_crypto_key.db_encryption_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}"
  ]

  depends_on = [
    google_project_service_identity.gcp_sa_cloud_sql
  ]
}

module "main" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "16.1.0"

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                 = "${var.prefix}-pgsql-${var.default_region}-${var.instance_name}"
  random_instance_name = true
  project_id           = var.project_id
  database_version     = var.db_version
  region               = var.default_region

  // Master configurations
  tier                            = var.db_tier
  zone                            = "${var.default_region}-a"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"
  deletion_protection             = var.enable_deletion_protection
  database_flags                  = [{ name = "autovacuum", value = "off" }]
  user_labels                     = var.labels

  ip_configuration = {
    # Private instance
    ipv4_enabled                                  = false
    require_ssl                                   = false
    private_network                               = var.network_selflink
    allocated_ip_range                            = null
    authorized_networks                           = var.authorized_networks
    enable_private_path_for_google_cloud_services = false
    psc_enabled                                   = true
    psc_allowed_consumer_projects                 = [var.project_id, var.network_project_id]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  db_name              = local.db_name
  db_charset           = "UTF8"
  db_collation         = "en_US.UTF8"
  additional_databases = []
  user_name            = var.root_user_username
  user_password        = var.root_user_password
  additional_users     = []
  encryption_key_name  = google_kms_crypto_key.db_encryption_key.id

  depends_on = [
    google_compute_global_address.reserved_ip_range,
    google_kms_crypto_key_iam_binding.db_encryption_iam
  ]
}



