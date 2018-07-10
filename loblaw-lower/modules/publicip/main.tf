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

# Create a public IP for the load balancer and assign a static
# address.
#
variable "pip_name" {}

variable "location" {}
variable "resource_group_name" {}

variable "domain_name" {
  default = "lcl-green-jumpbox"
}

variable "tag_description" {
  default = "Azure Kubernetes Services (AKS) Cluster"
}

variable "tag_environment" {
  default = "unknown"
}

variable "tag_billing" {}

resource "azurerm_public_ip" "pip" {
  name                         = "${var.pip_name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.domain_name}"

  tags {
    description = "${var.tag_description}"
    environment = "${var.tag_environment}"
    billing     = "${var.tag_billing}"
  }
}

output "ip_id" {
  value = "${azurerm_public_ip.pip.id}"
}

output "ip_fqdn" {
  value = "${azurerm_public_ip.pip.fqdn}"
}
