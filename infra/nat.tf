resource "google_compute_address" "cribl_static_address" {
  name         = "${var.gcp_app_name}-static-ip"
  network_tier = "PREMIUM"
  project      = var.gcp_project_id
  region       = var.region
}

module "cribl_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  name    = "${var.gcp_app_name}-router"
  project = var.gcp_project_id
  network = module.cribl_network.network_name
  region  = var.region

  nats = [{
    name                               = "${var.gcp_app_name}-nat"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    nat_ips                            = [google_compute_address.cribl_static_address.self_link]
    log_config = {
      enable = true
      filter = "ERRORS_ONLY"
    }
  }]
}
