resource "google_service_account" "vm_sa" {
  project      = var.project_id
  account_id   = "${var.prefix}-sa-glb-${var.instance_name}"
  display_name = "Service Account for Bastion host"
}

#Additional IAM role for bastion host to install Ops Agent
resource "google_project_iam_member" "vm_sa_role_binding" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
}

# KMS settings
data "google_project" "project" {
  project_id = var.project_id
}
module "disk_encryption_key" {
  source                   = "../gcp_kms_key"
  project_id               = var.project_id
  prefix                   = var.prefix
  default_region           = var.region
  kms_keyring_id           = var.kms_keyring_id
  kms_key_external_url     = var.kms_key_external_url
  kms_key_algorithm        = var.kms_key_algorithm
  kms_key_protection_level = var.kms_key_protection_level
  kms_key_name             = "bastion-vm-boot-disk"
  key_iam_permissions      = {
    "roles/cloudkms.cryptoKeyEncrypterDecrypter" = [
      "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
    ]
  }
}

# A bastion VM template to allow OS Login + IAP tunneling.
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.9"

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name_prefix         = "${var.prefix}-tmpl-${var.instance_name}"
  project_id          = var.project_id
  machine_type        = var.instance_type
  subnetwork          = var.subnet_self_link
  disk_encryption_key = module.disk_encryption_key.key_id

  service_account = {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  source_image_family  = split("/", var.instance_image)[1]
  source_image_project = split("/", var.instance_image)[0]

  labels = var.labels
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.9"

  project_id                   = var.project_id
  region                       = var.region
  #[prefix]-[resource]-[location]-[description]-[suffix]
  mig_name                     = "${var.prefix}-mig-${var.region}-${var.instance_name}"
  hostname                     = "${var.prefix}-vm-${var.region}-${var.instance_name}-mig"
  instance_template            = module.instance_template.self_link
  update_policy                = var.update_policy
  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control

  depends_on = [
    module.instance_template
  ]
}


# Additional OS login IAM bindings.
# https://cloud.google.com/compute/docs/instances/managing-instance-access#granting_os_login_iam_roles
resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = google_service_account.vm_sa.id
  role               = "roles/iam.serviceAccountUser"
  members            = var.authorized_members
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset(var.authorized_members)
  project  = var.project_id
  role     = "roles/compute.osLogin"
  member   = each.key
}

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 5.1"

  #[prefix]-[resource]-[location]-[description]-[suffix]
  fw_name_allow_ssh_from_iap = "${var.prefix}-fwr-glb-allow-ssh-from-iap-to-tunnel"
  project                    = var.project_id
  network                    = var.network_self_link
  service_accounts           = [google_service_account.vm_sa.email]
  instances                  = []
  members                    = var.authorized_members
}
