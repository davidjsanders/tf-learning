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

variable "nsg_name" {}

variable "tag_description" {
  default = "Azure Kubernetes Services (AKS) Cluster"
}

variable "tag_environment" {
  default = "unknown"
}

variable "tag_billing" {}

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
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    billing     = "${var.tag_billing}"
  }
}

output "nsg_id" {
  value = "${azurerm_network_security_group.app-nsg.id}"
}

output "nsg_name" {
  value = "${azurerm_network_security_group.app-nsg.name}"
}
