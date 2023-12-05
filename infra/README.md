
# Terraform Configuration

[[_TOC_]]

## Overview

This Terraform configuration is used to,
- Setup GCS (Google Cloud Storage) as the backend for storing the Terraform state files for Cribl infratructure.
- Setup a Service Account and IAM role and bindings to allow the Service Account to be used to provision Cribl infrastructure.


## Configuration

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=5.7.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >=5.7.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.12.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=5.7.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.12.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_app_name"></a> [gcp\_app\_name](#input\_gcp\_app\_name) | Prefix or the name to use for resources being provisioned for Cribl. | `string` | `"crubl"` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GCP Project ID. | `string` | `"cribl-406109"` | no |
| <a name="input_region"></a> [region](#input\_region) | The GCP region to provision infrastructure in. | `string` | `"europe-west2"` | no |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.cribl_static_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address) | resource |
| [helm_release.cribl_leader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Outputs

No outputs.