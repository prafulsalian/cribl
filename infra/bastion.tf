data "google_compute_network" "shared_vpc" {
  name    = var.tools_dept_shared_vpc_id
  project = var.tools_dept_gcp_project_id
}

data "google_compute_subnetwork" "shared_subnet" {
  name    = var.tools_dept_shared_vpc_subnet_id
  project = var.tools_dept_gcp_project_id
  region  = var.region
}

data "template_file" "startup_script" {
  template = <<-EOF
  sudo apt-get update -y
  sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
  sudo apt-get install -y apt-transport-https ca-certificates curl
  sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |  sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get install -y kubectl
  EOF
}

module "cribl_bastion_host" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~>6.0"

  network                    = data.google_compute_network.shared_vpc.self_link
  subnet                     = data.google_compute_subnetwork.shared_subnet.self_link
  project                    = var.gcp_project_id
  host_project               = var.tools_dept_gcp_project_id
  name                       = "${var.gcp_app_name}-jumpserver"
  region                     = var.region
  zone                       = var.zone
  image_project              = "debian-cloud"
  image_family               = "debian-10"
  machine_type               = "e2-small"
  disk_size_gb               = 10
  startup_script             = data.template_file.startup_script.rendered
  members                    = var.bastion_members
  service_account_roles      = var.bastion_iam_roles
  service_account_name       = "${var.gcp_app_name}-jumpserver-sa"
  fw_name_allow_ssh_from_iap = "allow-ssh-from-iap-to-tunnel-${var.gcp_app_name}-n-sec-${var.environment}"

  depends_on = [module.cribl_gcp_apis]
}

resource "google_project_iam_member" "compute_os_login" {
  for_each = toset(var.bastion_members)
  project = var.gcp_project_id
  role    = "roles/compute.osLogin"
  member  = each.key
}
