variable "organization_id" {}
variable "billing_account_id" {}
variable "parent_folder_id" {}

variable "project_name" {
  description = "Project name of the target project that contains the GKE cluster."
  default     = "tst-istio-start"
}

variable "cluster_name" {
  description = "Name for the GKE cluster."
  default     = "tst-istio-cluster"
}

variable "default_region" {
  description = "Region where the resources should be created."
  default     = "europe-west1"
}

variable "subnet_cidr_range" {
  description = "CIDR block to be used for the subnet that hosts the GKE cluster."
  default     = "10.0.0.0/16"
}

variable "master_cider_ipv4_block" {
  description = "CIDR block to allocate to the GKE master."
  default     = "172.16.0.32/28"
}

variable "enable_iap_node_access" {
  description = "Allow IAP access to the nodes if required."
  default     = false
}

variable "operator_ip_range" {
  description = "IP address range that will run the kubectl-commands to deploy the .yaml files."
}