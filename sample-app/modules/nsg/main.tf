# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       nsg.tf
# Purpose:        Create nsg.
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

variable "location" {}

variable "nsg_name" {}
variable "resource_prefix" {}

resource "azurerm_network_security_group" "app-nsg" {
  name                = "${var.nsg_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.3.0.0/26"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Production"
  }
}

output "nsg_id" {
  value = "${azurerm_network_security_group.app-nsg.id}"
}
