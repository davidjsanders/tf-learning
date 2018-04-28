# -------------------------------------------------------------------
#
# Module:         ScaleWeb - resource_group.tf
# Code set:       resource_group.tf
# Purpose:        Create a resource group
# Created on:     13 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Create the resource group which will be used to contain
# all resources. The default name is held in variables.tf
# and can be overridden by passing -var resource_group_name=
#
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}
variable "name" {}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "${var.environment}"
    name = "${var.name}"
  }
}

output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}
