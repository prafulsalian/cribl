terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=5.7.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=5.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
  # backend "gcs" {
  #   bucket  = "TBC"
  #   prefix  = "TBC"
  # }
}

provider "google" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"

  default_labels = {
    app = "cribl"
  }
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = "europe-west2"
  zone    = "europe-west2-a"

  default_labels = {
    app = "cribl"
  }
}

provider "kubernetes" {
  host                   = "https://${module.cribl_k8s_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.cribl_k8s_cluster.ca_certificate)
}

# provider "kubectl" {
#   host                   = "https://${module.cribl_k8s_cluster.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.cribl_k8s_cluster.ca_certificate)
# }

provider "helm" {
  kubernetes {
    host                   = "https://${module.cribl_k8s_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.cribl_k8s_cluster.ca_certificate)
  }
}

