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
variable "tag_billing" {}

resource "azurerm_container_service" "acs" {
  name                   = "${var.cluster_name}"
  location               = "${var.location}"
  resource_group_name    = "${var.resource_group_name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      = 1
    dns_prefix = "cowbull-master"
  }

  linux_profile {
    admin_username = "${var.linux_user}"

    ssh_key {
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  agent_pool_profile {
    name            = "${var.agent_pool_name}"
    count           = "${var.agent_pool_count}"
    vm_size         = "${var.agent_pool_vm_size}"
    dns_prefix      = "cowbull-agent"
  }

  service_principal {
    client_id     = "${var.sp_client_id}"
    client_secret = "${var.sp_client_secret}"
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    prefix = "${var.resource_prefix}"
    billing = "${var.tag_billing}"
  }
}

output "credentials" {
    value = "az aks get-credentials -g ${var.resource_group_name} -n ${var.cluster_name}"
}
