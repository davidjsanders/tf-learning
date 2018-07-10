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

variable "subnet_names" {
  type = "list"
}

variable "cidr_blocks" {
  type = "list"
}

variable "resource_group_name" {}

variable "vnet_name" {}

resource "azurerm_subnet" "subnets" {
  count                = "${length(var.subnet_names)}"
  name                 = "${element(var.subnet_names, count.index)}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.vnet_name}"
  address_prefix       = "${element(var.cidr_blocks, count.index)}"

  #  network_security_group_id = "${var.nsg_id}"
}

output "subnet_id_list" {
  value = ["${azurerm_subnet.subnets.*.id}"]
}
