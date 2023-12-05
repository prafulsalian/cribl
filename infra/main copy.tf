locals {
  project_id                  = "cribl-406109"
  cribl_provisioner_role_name = "cribl.provisionInfra"
  cribl_provisioner_sa_name   = "cribl-provisioner"
  tfstate_bucket_name         = "cribl-terraform-state"
}

resource "google_service_account" "service_accounts" {
  account_id   = local.cribl_provisioner_sa_name
  display_name = "Cribl Provisioner SA"
  description  = "Service account used to provision Cribl infrastructure in GCP."
  project      = local.project_id
}

module "cribl_provisioner_sa" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.2"

  project_id    = local.project_id
  names         = [local.cribl_provisioner_sa_name]
  display_name  = "Cribl Provisioner SA"
  description   = "Service account used to provision Cribl infrastructure in GCP."
  generate_keys = true
}

module "cribl_provisioner_role" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7"

  target_level = "project"
  target_id    = local.project_id
  role_id      = local.cribl_provisioner_role_name
  title        = "Cribl Infra Provisioning Role"
  description  = "Role with permissions required to provision Cribl infrastructure in GCP."

  # base_roles = [
  #   "roles/iam.serviceAccountAdmin",
  # ]

  permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
  excluded_permissions = []
  members              = ["serviceAccount:${local.cribl_provisioner_sa_name}@${local.project_id}.iam.gserviceaccount.com"]

  depends_on = [module.cribl_provisioner_sa]
}

module "tfstate_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  project_id    = local.project_id
  name          = local.tfstate_bucket_name
  location      = "EU"
  force_destroy = false
  versioning    = true

  iam_members = [{
    role   = "roles/storage.objectUser"
    member = "serviceAccount:${local.cribl_provisioner_sa_name}@${local.project_id}.iam.gserviceaccount.com"
  }]

  depends_on = [module.cribl_provisioner_role]
}
