# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      subnet
# Code set:       main.tf
# Purpose:        Create an Azure subnet
# Created on:     19 May 2018
# Created by:     David Sanders
# Creator email:  david.sanders2@loblaw.ca
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "resource_group_name" {}

variable "subnet_cidr_block" {}
variable "vnet_name" {}
variable "nsg_id" {}
variable "subnet_name" {}

resource "azurerm_subnet" "vmss" {
  name                      = "${var.subnet_name}"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.vnet_name}"
  address_prefix            = "${var.subnet_cidr_block}"
  network_security_group_id = "${var.nsg_id}"
}

output "subnet_id" {
  value = "${azurerm_subnet.vmss.id}"
}
