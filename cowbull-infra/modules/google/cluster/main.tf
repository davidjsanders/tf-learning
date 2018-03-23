variable "region" {}
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "zone" {}
variable "username" {}
variable "password" {}
variable "project_id" {}

resource "google_container_cluster" "primary" {
  name    = "${var.cluster_name}"
  project = "${var.project_id}"
  zone    = "${var.region}-${var.zone}"

  #  zone               = "${data.google_compute_zones.available.names[0]}"
  initial_node_count = 3

  node_version       = "${var.kubernetes_version}"
  min_master_version = "${var.kubernetes_version}"

  #  additional_zones = [
  #    "${data.google_compute_zones.available.names[1]}",
  #  ]

  master_auth {
    username = "${var.username}"
    password = "${var.password}"
  }
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "cluster_name" {
  value = "${google_container_cluster.primary.name}"
}

output "cluster_credentials" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --project ${var.project_id} --zone ${var.region}"
}

output "primary_zone" {
  value = "${google_container_cluster.primary.zone}"
}

output "additional_zones" {
  value = "${google_container_cluster.primary.additional_zones}"
}

output "endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}

output "node_version" {
  value = "${google_container_cluster.primary.node_version}"
}
