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

variable "ip_id" {}
variable "vm_size" { default = "Standard_DS1_v2" }
variable "vm_name" {}
variable "vm_os_name" {}
variable "vm_admin_user" { default = "azureuser" }
variable "vm_admin_password" { default = "Password1234!" }
variable "vm_disable_password_authentication" { default = true }
variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "environment" {}
variable "name" {}
