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

# Create the subnet for resources (10.0.2.0/24). Typically,
# there would be more than one subnet to segregate traffic
# but in this example, only one is used.
#
variable "resource_group_name" {}

variable "subnet_cidr_block" {}
variable "vnet_name" {}
variable "nsg_id" {}
variable "resource_prefix" {}

resource "azurerm_subnet" "vmss" {
  name                      = "${var.resource_prefix}-vnet-subnet1"
  resource_group_name       = "${var.resource_group_name}"
  virtual_network_name      = "${var.vnet_name}"
  address_prefix            = "${var.subnet_cidr_block}"
  network_security_group_id = "${var.nsg_id}"
}

output "subnet_id" {
  value = "${azurerm_subnet.vmss.id}"
}
