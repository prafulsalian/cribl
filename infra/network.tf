module "cribl_network" {
  source  = "terraform-google-modules/network/google"
  version = "~>8.0"

  project_id   = var.gcp_project_id
  network_name = var.gcp_app_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name               = "${var.gcp_app_name}-primary"
      subnet_ip                 = "10.10.0.0/16"
      subnet_region             = var.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_sampling = 1
      description               = "Cribl Primary Subnet"
    }
  ]
  secondary_ranges = {
    "${var.gcp_app_name}-primary" = [
      {
        range_name    = "${var.gcp_app_name}-secondary-pods"
        ip_cidr_range = "10.20.0.0/24"
      },
      {
        range_name    = "${var.gcp_app_name}-secondary-services"
        ip_cidr_range = "10.20.1.0/24"
      },
    ]
  }
}
