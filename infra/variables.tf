variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID."
  default     = "cribl-406109"
}

variable "gcp_app_name" {
  type        = string
  description = "Prefix or the name to use for resources being provisioned for Cribl."
  default     = "crubl"
}

variable "region" {
  type        = string
  description = "The GCP region to provision infrastructure in."
  default     = "europe-west2"
}
