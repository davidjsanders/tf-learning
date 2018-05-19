# -------------------------------------------------------------------
#
# Module:         modules
# Submodule:      rg
# Code set:       main.tf
# Purpose:        Create an Azure resource group
# Created on:     19 May 2018
# Created by:     David Sanders
# Creator email:  david.sanders2@loblaw.ca
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

variable "resource_group_name" {}

variable "location" {
  default = "eastus"
}

variable "tag_description" {
  default = "Azure Kubernetes Services (AKS) Cluster"
}

variable "tag_environment" {
  default = "unknown"
}

variable "tag_billing" {}

# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    billing     = "${var.tag_billing}"
  }
}

output "resource_group_name" {
  value = "${azurerm_resource_group.resource_group.name}"
}

output "resource_group_id" {
  value = "${azurerm_resource_group.resource_group.id}"
}
