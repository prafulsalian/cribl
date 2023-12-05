data "google_client_config" "default" {}

module "cribl_k8s_cluster" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version                    = "~>29.0"
  description                = "GKE Cluster for Cribl."
  project_id                 = var.gcp_project_id
  name                       = var.gcp_app_name
  regional                   = true
  region                     = var.region
  network                    = module.cribl_network.network_name
  subnetwork                 = module.cribl_network.subnets_names[0]
  kubernetes_version         = "latest"
  ip_range_pods              = "${var.gcp_app_name}-secondary-pods"
  ip_range_services          = "${var.gcp_app_name}-secondary-services"
  release_channel            = "REGULAR"
  horizontal_pod_autoscaling = true
  http_load_balancing        = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  deletion_protection        = false
}
