output "project_id" {
  value = module.istio_starter_project.project_id
}

output "project_number" {
  value = module.istio_starter_project.project_number
}

output "gke_cluster_credentials" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gke_cluster.name} --region ${var.default_region} --project ${module.istio_starter_project.project_id}"
}

output "cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "static_ingress_address" {
  value = google_compute_global_address.static_lb_address.address
}

output "static_ingress_address_name" {
  value = google_compute_global_address.static_lb_address.name
}



