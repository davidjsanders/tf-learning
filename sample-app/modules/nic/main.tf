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

# Create a network interface and assign a public ip to it.
#
variable "if_name" {
  default = "eth"
}

variable "ip_name" {
  default = "ipconfig"
}

variable "subnet_id" {}
variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "environment" {}
variable "name" {}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  # Configure the interface to use the Public IP
  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
  }

  tags {
    environment = "${var.environment}"
  }
}

output "id" {
  value = "${azurerm_network_interface.nic.id}"
}
