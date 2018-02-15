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

# Create a load balancer probe for health checking. In this case
# the probe checks against the application port (default 8080)
# to ensure resources being load balanced are healthy.
#
variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "port" {}
variable "resource_prefix" {}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${var.loadbalancer_id}"
  name                = "${var.resource_prefix}-ssh-running-probe"
  port                = "${var.port}"
}

output "lb_probe_id" {
    value = "${azurerm_lb_probe.vmss.id}"
}
