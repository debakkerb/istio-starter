locals {
  gke_operator_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
  ]
}

module "istio_starter_project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.0"

  name              = var.project_name
  random_project_id = true
  org_id            = var.organization_id
  billing_account   = var.billing_account_id
  folder_id         = var.parent_folder_id

  activate_apis = [
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "containerregistry.googleapis.com",
    "bigquery.googleapis.com",
    "pubsub.googleapis.com"
  ]
}

resource "google_service_account" "gke_cluster_account" {
  project      = module.istio_starter_project.project_id
  account_id   = "gke-sm-sa"
  display_name = "Service Mesh Service Account"
  description  = "Service Account to attach to the GKE cluster."
}

resource "google_project_iam_member" "sa_gke_permissions" {
  for_each = toset(local.gke_operator_sa_roles)
  project  = module.istio_starter_project.project_id
  member   = "serviceAccount:${google_service_account.gke_cluster_account.email}"
  role     = each.value
}