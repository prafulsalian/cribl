variable "environment" {
  type        = string
  description = "The Cribl environment name."
  default     = "dev"
}

variable "gke_cluster_version" {
  type        = string
  description = "The stable kubernetes version to use to provision the GKE Autopilot cluster for Cribl."
  # Need to check if this should be set or not given that we are using Autopilot
  default = "1.27.5-gke.200"
}

variable "gcp_project_id" {
  type        = string
  description = "GCP project ID for Cribl DEV environment."
  default     = "cribl-406109v"
}

variable "gcp_app_name" {
  type        = string
  description = "Prefix or the name to use for resources being provisioned for Cribl."
  default     = "cribl"
}

variable "region" {
  type        = string
  description = "The GCP region to provision infrastructure in."
  default     = "europe-west2"
}

variable "zone" {
  type        = string
  description = "The GCP zone to provision infrastructure in."
  default     = "europe-west2-a"
}

variable "tools_dept_shared_vpc_id" {
  type        = string
  description = "ID of the shared VPC network in GCP for the Tools department."
  default     = "svpc-vo-n-sec-01"
}

variable "tools_dept_shared_vpc_subnet_id" {
  type        = string
  description = "ID of the subnet in the shared VPC network in GCP for the Tools department."
  default     = "snet-vo-ew2-n-sec-01"
}

variable "tools_dept_pod_ip_range_name" {
  type        = string
  description = "Name of the secondary subnet IP range of the shared VPC subnet to use for pods."
  default     = "snet-vo-ew2-n-sec-01-pods"
}

variable "tools_dept_svc_ip_range_name" {
  type        = string
  description = "Name of the secondary subnet IP range of the shared VPC subnet to use for services."
  default     = "snet-vo-ew2-n-sec-01-svc"
}

variable "tools_dept_gcp_project_id" {
  type        = string
  description = "ID of the shared VPC project in GCP for the Tools department."
  default     = "prj-vo-n-sec-svpc-01-2903"
}

variable "gke_nodepool_iam_roles" {
  type        = list(string)
  description = "Default IAM roles for the Cribl GKE cluster node pool service account."
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
    "roles/container.serviceAgent",
    "roles/artifactregistry.reader",
    "roles/iam.serviceAccountUser",
    "roles/container.nodeServiceAccount",
    "roles/container.hostServiceAgentUser",
    "roles/container.developer",
    "roles/container.clusterViewer",
    "roles/cloudkms.viewer",
    "roles/iam.workloadIdentityUser",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  ]
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The CIDR range to use for assigning private IPs to the GKE cluster control plane resources."
  default     = "10.45.35.0/28"
}

variable "master_authorized_networks" {
  description = "The master authorized networks that are allowed access to the GKE cluster control plane API endpoint."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "34.89.29.189/32"
      display_name = "vmo2-tools GitLab runners"
    },
    {
      cidr_block   = "35.189.73.203/32"
      display_name = "vmo2-tools GitLab runners"
    }
  ]
}

variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the Cribl bastion host."
  default     = ["user:praful.salian@virginmediao2.co.uk"]
}

variable "bastion_iam_roles" {
  type        = list(string)
  description = "Default IAM roles for the Cribl Bastion host service account."
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/compute.osLogin",
    "roles/iam.serviceAccountViewer"
  ]
}
