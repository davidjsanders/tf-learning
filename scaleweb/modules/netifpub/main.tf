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
resource "azurerm_network_interface" "nif" {
  name                = "${var.resource_prefix}-${var.if_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  # Configure the interface to use the Public IP
  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${var.ip_public_id}"
  }

  tags {
    environment = "${var.environment}"
    name = "${var.name}"
  }
}

output "netif_id" {
  value = "${azurerm_network_interface.nif.id}"
}

