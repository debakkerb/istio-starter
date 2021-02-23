resource "google_compute_network" "service_mesh_network" {
  project                 = module.istio_starter_project.project_id
  name                    = "istio-starter-nw"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "service_mesh_subnet" {
  project                  = module.istio_starter_project.project_id
  network                  = google_compute_network.service_mesh_network.self_link
  name                     = "istio-starter-snw"
  ip_cidr_range            = var.subnet_cidr_range
  region                   = var.default_region
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.1.0.0/24"
  }

  secondary_ip_range {
    range_name    = "svc-range"
    ip_cidr_range = "10.2.0.0/24"
  }
}

resource "google_compute_firewall" "pilot_rule" {
  project     = module.istio_starter_project.project_id
  name        = "gke-master-pilot"
  description = "Allow Pilot access for Istio on the Master"
  network     = google_compute_network.service_mesh_network.self_link
  direction   = "INGRESS"
  priority    = 1000

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["15017", "443", "10250"]
  }

  source_ranges = [
    var.master_cider_ipv4_block
  ]

  target_tags = [
    "gke-nodes"
  ]

}

resource "google_compute_global_address" "static_lb_address" {
  project = module.istio_starter_project.project_id
  name    = "istio-starter-global-ip"
}

resource "google_compute_firewall" "iap_access" {
  count     = var.enable_iap_node_access ? 1 : 0
  project   = module.istio_starter_project.project_id
  name      = "iap-access"
  network   = google_compute_network.service_mesh_network.self_link
  direction = "INGRESS"

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["gke-nodes"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}