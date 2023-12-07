module "cribl_gcp_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.4"

  project_id                  = var.gcp_project_id
  disable_services_on_destroy = false

  activate_apis = [
    "dataproc.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudasset.googleapis.com",
    "serviceusage.googleapis.com",
    "recommender.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "storage-component.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
  ]
}
