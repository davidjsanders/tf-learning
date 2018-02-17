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

variable "if_name" { default = "eth" }
variable "ip_name" { default = "ipconfig"}
variable "ip_public_id" {}
variable "subnet_id" {}
variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "environment" {}
variable "name" {}
