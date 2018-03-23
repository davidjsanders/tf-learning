provider "google" {
  region  = "${var.region}"
  project = "${var.tfadmin_project}"
}

variable "cluster_name" {
  default = "terraform-example-cluster"
}

variable "region" {}
variable "zone" {}
variable "kubernetes_version" {}
variable "username" {}
variable "password" {}
variable "billing_account" {}
variable "project_name" {}
variable "org_id" {}
variable "tfadmin_project" {}

#data "google_compute_zones" "available" {}
#
module "project" {
  source = "../modules/google/project"

  project_name    = "${var.project_name}"
  billing_account = "${var.billing_account}"
  org_id          = "${var.org_id}"
}

module "cluster" {
  source = "../modules/google/cluster"

  project_id         = "${module.project.project_id}"
  region             = "${var.region}"
  zone               = "${var.zone}"
  cluster_name       = "${var.cluster_name}"
  kubernetes_version = "${var.kubernetes_version}"
  username           = "${var.username}"
  password           = "${var.password}"
}

output "project_id" {
  value = "${module.project.project_id}"
}

output "cluster_credentials" {
  value = "${module.cluster.cluster_credentials}"
}
