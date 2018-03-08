# -------------------------------------------------------------------
#
# Module:         aks
# Submodule:      dev
# Code set:       main.tf
# Purpose:        Deploy an Azure Kubernetes Cluster
# Created on:     24 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Cloud Service Provider variables
variable "cloud" { default = "google" }

# General variables applying to ALL modules
variable "resource_prefix" { default = "noprefix" }
variable "resource_group_name" { }
variable "location" { default = "eastus" }
variable "tag_description" { default = "Azure Kubernetes Services (AKS) Cluster" }
variable "tag_environment" { default = "unknown" }

# AKS cluster variables
variable "cluster_name" { default = "aks-cluster" }
variable "kubernetes_version" { default = "1.8.2" }
variable "dns_prefix" { default = "nodnsprefixprovided" }
variable "linux_user" { default = "aksuser" }
#variable "linux_user_key" {}
variable "agent_pool_name" { default = "pool" }
variable "sp_client_id" {}
variable "sp_client_secret" {}
variable "tag_billing" {}

# Configure the resource group
module "resource_group" {
    source = "../modules/azure/rg"

    resource_prefix = "dev-${var.resource_prefix}"
    resource_group_name = "${var.resource_group_name}"
    location = "${var.location}"
    tag_description = "${var.tag_description}"
    tag_environment = "${var.tag_environment}"
    tag_billing = "${var.tag_billing}"
}

# Create the AKS service
module "aks" {
    source = "../modules/azure/cluster"

    cluster_name = "dev-${var.resource_prefix}-cowbull-cluster"
    kubernetes_version = "${var.kubernetes_version}"
    dns_prefix = "dev-${var.resource_prefix}-cluster"
    linux_user = "dev-cowbull"
    linux_user_key = "${file("~/.ssh/id_rsa.pub")}"
    agent_pool_name = "dev${var.resource_prefix}"
    agent_pool_vm_size = "Standard_D2_v2"
    agent_pool_os_type = "Linux"
    agent_pool_count = "3"
    sp_client_id = "${var.sp_client_id}"
    sp_client_secret = "${var.sp_client_secret}"

    resource_prefix = "${var.resource_prefix}"
    resource_group_name = "${module.resource_group.resource_group_name}"
    location = "${var.location}"
    tag_description = "${var.tag_description}"
    tag_environment = "${var.tag_environment}"
    tag_billing = "${var.tag_billing}"
}

output "resource_group_name" {
    value = "${module.resource_group.resource_group_name}"
}

output "resource_group_id" {
    value = "${module.resource_group.resource_group_id}"
}

output "credentials" {
    value = "${module.aks.credentials}"
}
