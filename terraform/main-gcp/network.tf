/******************************************
  Create Network with internet access
*****************************************/

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 8.0"

  project_id   = var.gcp_project_id
  network_name = "${var.prefix}-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "private-subnet"
      subnet_ip     = var.network_ip_range
      subnet_region = var.gcp_region
    }
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      #tags              = "egress-internet"
      next_hop_internet = "true"
    }
  ]
  egress_rules = [
    {
      name               = "fwtest-allow-egress-internet"
      description        = "Allow all EGRESS to internet"
      destination_ranges = ["0.0.0.0/0"]
      allow              = [
        {
          protocol = "tcp"
          ports    = null # all ports
        }
      ]

    },
  ]
}

/******************************************
  NAT Cloud Router & NAT config
 *****************************************/

resource "google_compute_address" "nat_external_addresses" {

  project      = var.gcp_project_id
  #[prefix]-[resource]-[location]-[description]-[suffix]
  name         = "${var.prefix}-ca-${var.gcp_region}-1"
  region       = var.gcp_region
  address_type = "EXTERNAL"
}

resource "google_compute_router" "nat_router" {

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name    = "${var.prefix}-cr-${var.gcp_region}-nat"
  project = var.gcp_project_id
  region  = var.gcp_region
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "egress_nat_region1" {

  #[prefix]-[resource]-[location]-[description]-[suffix]
  name                               = "${var.prefix}-rn-${var.gcp_region}-egress"
  project                            = var.gcp_project_id
  router                             = google_compute_router.nat_router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_external_addresses.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
