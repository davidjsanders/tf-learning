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

# Create a NAT rule to allow the load balancer to pass traffic
# to the backend resources. In this case, take traffic on port
# 80 and pass it on to the application port (default 8080)
#
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "loadbalancer_id" {}
variable "frontend_port" {}
variable "application_port" {}
variable "be_address_pool_id" {}
variable "lb_fe_config_name" {}
variable "lb_probe_id" {}
variable "lb_name" {}
variable "lb_protocol" {}

resource "azurerm_lb_rule" "lbnatrule" {
    resource_group_name            = "${var.resource_group_name}"
    loadbalancer_id                = "${var.loadbalancer_id}"
    name                           = "${var.lb_name}"
    protocol                       = "${var.lb_protocol}"
    frontend_port                  = "${var.frontend_port}"
    backend_port                   = "${var.application_port}"
    backend_address_pool_id        = "${var.be_address_pool_id}"
    frontend_ip_configuration_name = "${var.lb_fe_config_name}"
    probe_id                       = "${var.lb_probe_id}"
}
