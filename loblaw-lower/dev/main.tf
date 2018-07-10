# -------------------------------------------------------------------
#
# Module:         loblaw-lower
# Submodule:      dev
# Code set:       main.tf
# Purpose:        Deploy the Loblaw Lower environment using terraform
#                 to provision the shared VNET
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

variable "cidr_block" {
  default = "10.0.0.0/24"
}

variable "subnet_names" {
  type = "list"
}

variable "cidr_blocks" {
  type = "list"
}

variable "nsg_names" {
  type = "list"
}

variable "ssh_enable_subnet" {
  default = "2"
}

# variable "dc_cidr_block" {}

# variable "int_cidr_block" {}
# variable "svc_cidr_block" {}
# variable "gateway_cidr_block" {}

variable "tag_description" {}

variable "tag_environment" {}

variable "tag_billing" {}

# Configure the resource group
module "resource_group" {
  source = "../modules/rg"

  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tag_description     = "${var.tag_description}"
  tag_environment     = "${var.tag_environment}"
  tag_billing         = "${var.tag_billing}"
}

module "virtual_network" {
  source              = "../modules/vnet"
  vnet_name           = "lcl-shared-vnet"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"
  cidr_block          = "${var.cidr_block}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "nsgs" {
  source = "../modules/nsg"

  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"
  nsg_names           = "${var.nsg_names}"
  tag_description     = "${var.tag_description}"
  tag_environment     = "${var.tag_environment}"
  tag_billing         = "${var.tag_billing}"
}

module "gateway_subnet_nsg_allow_ssh" {
  source = "../modules/nsg_rule"

  resource_group_name    = "${module.resource_group.resource_group_name}"
  nsg_name               = "${element(module.nsgs.nsg_names, var.ssh_enable_subnet)}"
  rule_name              = "allow_gateway_ssh"
  priority               = "1000"
  direction              = "Inbound"
  destination_port_range = "22"
}

module "subnets" {
  source = "../modules/subnet"

  resource_group_name = "${module.resource_group.resource_group_name}"
  vnet_name           = "${module.virtual_network.vnet_name}"
  subnet_names        = "${var.subnet_names}"
  cidr_blocks         = "${var.cidr_blocks}"
}

module "linux_jump_pip" {
  source = "../modules/publicip"

  pip_name            = "linux_jump_pip"
  domain_name         = "lcl-dv-green"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "linux_jump_nic" {
  source = "../modules/nic"

  subnet_id            = "${element(module.subnets.subnet_id_list, 2)}"
  resource_group_name  = "${module.resource_group.resource_group_name}"
  location             = "${var.location}"
  public_ip_address_id = "${module.linux_jump_pip.ip_id}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "linux_jump" {
  source = "../modules/ubuntu-vm"

  vm_name             = "linux_jumpbox"
  vm_os_name          = "linux-jumpbox"
  nic_id              = "${module.linux_jump_nic.id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

output "resource_group_name" {
  value = "${module.resource_group.resource_group_name}"
}

output "resource_group_id" {
  value = "${module.resource_group.resource_group_id}"
}

output "jumpbox_ssh" {
  value = "ssh -A azureuser@${module.linux_jump_pip.ip_fqdn}"
}
