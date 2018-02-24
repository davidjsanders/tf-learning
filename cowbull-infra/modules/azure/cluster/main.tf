# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      rg
# Code set:       main.tf
# Purpose:        Create an Azure resource group
# Created on:     24 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "cluster_name" {}
variable "kubernetes_version" {}
variable "dns_prefix" {}
variable "linux_user" {}
variable "linux_user_key" {}
variable "agent_pool_name" {}
variable "agent_pool_count" {}
variable "agent_pool_vm_size" {}
variable "agent_pool_os_type" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}

variable "resource_prefix" {}
variable "resource_group_name" {}
variable "location" {}
variable "tag_description" {}
variable "tag_environment" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                   = "${var.cluster_name}"
  location               = "${var.location}"
  resource_group_name    = "${var.resource_group_name}"
  kubernetes_version     = "${var.kubernetes_version}"
  dns_prefix             = "${var.dns_prefix}"

  linux_profile {
    admin_username = "${var.linux_user}"

    ssh_key {
      key_data = "${var.linux_user_key}"
    }
  }

  agent_pool_profile {
    name            = "${var.resource_prefix}${var.agent_pool_name}"
    count           = "${var.agent_pool_count}"
    vm_size         = "${var.agent_pool_vm_size}"
    os_type         = "${var.agent_pool_os_type}"
  }

  service_principal {
    client_id     = "${var.sp_client_id}"
    client_secret = "${var.sp_client_secret}"
  }

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    prefix = "${var.resource_prefix}"
  }
}

output "credentials" {
    value = "az aks get-credentials -g ${var.resource_group_name} -n ${var.cluster_name}"
}
