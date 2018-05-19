# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      vnet
# Code set:       main.tf
# Purpose:        Create an Azure virtual network
# Created on:     19 May 2018
# Created by:     David Sanders
# Creator email:  david.sanders2@loblaw.ca
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "vnet_name" {}
variable "resource_group_name" {}
variable "cidr_block" {}
variable "location" {}
variable "tag_description" {}
variable "tag_environment" {}
variable "tag_billing" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  address_space       = ["${var.cidr_block}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    billing     = "${var.tag_billing}"
  }
}

output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
}
