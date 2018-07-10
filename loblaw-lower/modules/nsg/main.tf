# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      nsg
# Code set:       main.tf
# Purpose:        Create an Azure network security group
# Created on:     19 May 2018
# Created by:     David Sanders
# Creator email:  david.sanders2@loblaw.ca
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "resource_group_name" {}

variable "location" {}

variable "nsg_names" {
  type = "list"
}

variable "tag_description" {
  default = "Azure Kubernetes Services (AKS) Cluster"
}

variable "tag_environment" {
  default = "unknown"
}

variable "tag_billing" {}

resource "azurerm_network_security_group" "nsg_list" {
  count               = "${length(var.nsg_names)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  name                = "${element(var.nsg_names, count.index)}"

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    billing     = "${var.tag_billing}"
  }
}

output "nsg_ids" {
  value = ["${azurerm_network_security_group.nsg_list.*.id}"]
}

output "nsg_names" {
  value = ["${azurerm_network_security_group.nsg_list.*.name}"]
}
