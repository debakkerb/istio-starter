resource "google_container_registry" "container_registry" {
  project = module.istio_starter_project.project_id
}

resource "google_pubsub_topic" "gke_upgrade_notifications" {
  project = module.istio_starter_project.project_id
  name    = "${var.cluster_name}-notif"

  message_storage_policy {
    allowed_persistence_regions = [
    var.default_region]
  }
}

resource "google_container_cluster" "gke_cluster" {
  project  = module.istio_starter_project.project_id
  provider = google-beta

  name        = var.cluster_name
  description = "GKE Cluster to run the Service Mesh application."
  location    = var.default_region
  network     = google_compute_network.service_mesh_network.self_link
  subnetwork  = google_compute_subnetwork.service_mesh_subnet.self_link

  remove_default_node_pool = true
  initial_node_count       = 1
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  enable_shielded_nodes    = true
  enable_legacy_abac       = false

  workload_identity_config {
    identity_namespace = "${module.istio_starter_project.project_id}.svc.id.goog"
  }

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  release_channel {
    channel = "RAPID"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "svc-range"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = google_compute_subnetwork.service_mesh_subnet.ip_cidr_range
    }

    cidr_blocks {
      cidr_block = var.operator_ip_range
    }
  }

  notification_config {
    pubsub {
      enabled = true
      topic   = google_pubsub_topic.gke_upgrade_notifications.id
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_cider_ipv4_block
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  node_config {
    service_account = google_service_account.gke_cluster_account.email
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]

    tags = [
      "gke-nodes"
    ]
  }

  timeouts {
    create = "20m"
    update = "30m"
  }

}

resource "google_container_node_pool" "gke_node_pool" {
  provider   = google-beta
  project    = module.istio_starter_project.project_id
  name       = "${var.cluster_name}-nodes"
  cluster    = google_container_cluster.gke_cluster.name
  location   = var.default_region
  node_count = 1

  node_config {
    image_type      = "COS_CONTAINERD"
    machine_type    = "n2-standard-8"
    service_account = google_service_account.gke_cluster_account.email
    oauth_scopes = [
      "storage-ro",
      "logging-write",
      "monitoring"
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    disk_size_gb = 20
    disk_type    = "pd-ssd"

    tags = [
      "gke-nodes"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  timeouts {
    create = "30m"
    update = "40m"
    delete = "2h"
  }
}