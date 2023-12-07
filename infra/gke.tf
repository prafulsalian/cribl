data "google_client_config" "default" {}

module "cribl_gke_node_pool_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2"

  project_id    = var.gcp_project_id
  names         = ["${var.gcp_app_name}-gke-nodepool-sa"]
  description   = "Service account used by the Cribl GKE cluster node pool."
  generate_keys = false

  depends_on = [module.cribl_gcp_apis]
}

resource "google_project_iam_member" "cribl_gke_node_pool_sa_roles" {
  for_each = toset(var.gke_nodepool_iam_roles)
  project = var.gcp_project_id
  role    = each.key
  member  = "serviceAccount:${module.cribl_gke_node_pool_sa.email}"
}

module "cribl_k8s_cluster" {
  source             = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version            = "~>29.0"
  description        = "GKE cluster for Cribl Devenvironment."
  project_id         = var.gcp_project_id
  name               = var.gcp_app_name
  regional           = true
  region             = var.region
  kubernetes_version = var.gke_cluster_version
  network            = var.tools_dept_shared_vpc_id
  subnetwork         = var.tools_dept_shared_vpc_subnet_id
  network_project_id = var.tools_dept_gcp_project_id
  ip_range_pods      = var.tools_dept_pod_ip_range_name
  ip_range_services  = var.tools_dept_svc_ip_range_name
  # network                    = module.cribl_network.network_name
  # subnetwork                 = module.cribl_network.subnets_names[0]
  # ip_range_pods              = "${var.gcp_app_name}-secondary-pods"
  # ip_range_services          = "${var.gcp_app_name}-secondary-services"
  release_channel            = "STABLE"
  create_service_account     = false
  service_account            = module.cribl_gke_node_pool_sa.email
  master_authorized_networks = var.master_authorized_networks
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  horizontal_pod_autoscaling = true
  http_load_balancing        = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  deletion_protection        = true
  depends_on = [
    module.cribl_gke_node_pool_sa,
    google_project_iam_member.cribl_gke_node_pool_sa_roles
  ]
}
