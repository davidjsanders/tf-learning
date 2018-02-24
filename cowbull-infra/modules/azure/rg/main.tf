# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      rg
# Code set:       main.tf
# Purpose:        Create an Azure resource group
# Created on:     24 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "resource_prefix" { default = "noprefix" }
variable "resource_group_name" { }
variable "location" { default = "eastus" }
variable "tag_description" { default = "Azure Kubernetes Services (AKS) Cluster" }
variable "tag_environment" { default = "unknown" }

# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_prefix}-${var.resource_group_name}"
  location = "${var.location}"

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    prefix = "${var.resource_prefix}"
  }
}

output "resource_group_name" { 
    value = "${azurerm_resource_group.resource_group.name}"
}

output "resource_group_id" { 
    value = "${azurerm_resource_group.resource_group.id}"
}
