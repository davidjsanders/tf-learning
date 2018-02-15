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

# Create a load balancer and tell it to use the Public IP created
# above.
#
variable "resource_prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "public_ip_id" {}
variable "environment" {}
variable "name" {}
variable "private_fe_config_name" {
  default = "PublicIPAddress"
}

resource "azurerm_lb" "lb" {
  name                = "${var.resource_prefix}-load-balancer"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  frontend_ip_configuration {
    name                 = "${var.private_fe_config_name}"
    public_ip_address_id = "${var.public_ip_id}"
  }

  tags {
    environment = "${var.environment}"
    name = "${var.name}"
  }
}

output "lb_id" {
  value = "${azurerm_lb.lb.id}"
}

output "lb_fe_config_name" {
  value = "${var.private_fe_config_name}"
}
