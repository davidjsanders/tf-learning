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

variable "scaleset_name" {
    default = "scaleset"
}
variable "upgrade_policy_mode" {
    default = "Manual"
}
variable "sku_name" {
    default = "Standard_DS1_v2"
}
variable "sku_tier" {
    default = "Standard"
}
variable "sku_qty" {
    default = "2"
}
variable "data_disk_size_gb" {
    default = 10
}
variable "instance_name_prefix" {
    default = "dev"
}

variable "lb_rule_name" {}
variable "application_port" {}
variable "bepool_id" {}
variable "subnet_id" {}
variable "resource_prefix" {}
variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "name" {}
