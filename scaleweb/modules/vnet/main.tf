# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       vmss.tf
# Purpose:        Create a scaled webserver farm with a bastion
#                 server to enable connection to resources via ssh.
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Create the virtual network which will be used to contain
# all resources. The default name is held in variables.tf
# and can be overridden by passing -var azurerm_virtual_network=
#
# Notice the CIDR block is set to a default of 10.0.0.0/20 which
# is way too big.
#
variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "name" {}
variable "cidr_block" {}

resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["${var.cidr_block}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  tags {
    environment = "${var.environment}"
    name = "${var.name}"
  }
}

output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
}
