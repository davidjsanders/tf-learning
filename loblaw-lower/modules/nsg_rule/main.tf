# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      nsg_rule
# Code set:       main.tf
# Purpose:        Create an Azure network security group
# Created on:     19 May 2018
# Created by:     David Sanders
# Creator email:  david.sanders2@loblaw.ca
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "rule_name" {}

variable "priority" {
  default = 100
}

variable "direction" {
  default = "Inbound"
}

variable "access" {
  default = "Allow"
}

variable "protocol" {
  default = "Tcp"
}

variable "source_port_range" {
  default = "*"
}

variable "destination_port_range" {
  default = "*"
}

variable "source_address_prefix" {
  default = "*"
}

variable "destination_address_prefix" {
  default = "*"
}

variable "resource_group_name" {}

variable "nsg_name" {}

resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = "${var.rule_name}"
  priority                    = "${var.priority}"
  direction                   = "${var.direction}"
  access                      = "${var.access}"
  protocol                    = "${var.protocol}"
  source_port_range           = "${var.source_port_range}"
  destination_port_range      = "${var.destination_port_range}"
  source_address_prefix       = "${var.source_address_prefix}"
  destination_address_prefix  = "${var.destination_address_prefix}"
  resource_group_name         = "${var.resource_group_name}"
  network_security_group_name = "${var.nsg_name}"
}

output "nsg_rule_id" {
  value = "${azurerm_network_security_rule.nsg_rule.id}"
}
