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

variable "dc_cidr_block" {}
variable "int_cidr_block" {}
variable "svc_cidr_block" {}
variable "gateway_cidr_block" {}

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

module "dc_subnet_nsg" {
  source = "../modules/nsg"

  nsg_name            = "lcl-shared-dc-subnet-nsg"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "svc_subnet_nsg" {
  source = "../modules/nsg"

  nsg_name            = "lcl-shared-svc-subnet-nsg"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "int_subnet_nsg" {
  source = "../modules/nsg"

  nsg_name            = "lcl-shared-inet-subnet-nsg"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "gateway_subnet_nsg" {
  source = "../modules/nsg"

  nsg_name            = "lcl-shared-gateway-subnet-nsg"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location            = "${var.location}"

  tag_description = "${var.tag_description}"
  tag_environment = "${var.tag_environment}"
  tag_billing     = "${var.tag_billing}"
}

module "dc_subnet" {
  source = "../modules/subnet"

  subnet_name         = "lcl-green-dc-subnet"
  subnet_cidr_block   = "${var.dc_cidr_block}"
  vnet_name           = "${module.virtual_network.vnet_name}"
  nsg_id              = "${module.dc_subnet_nsg.nsg_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
}

module "int_subnet" {
  source = "../modules/subnet"

  subnet_name         = "lcl-green-int-subnet"
  subnet_cidr_block   = "${var.int_cidr_block}"
  vnet_name           = "${module.virtual_network.vnet_name}"
  nsg_id              = "${module.int_subnet_nsg.nsg_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
}

module "svc_subnet" {
  source = "../modules/subnet"

  subnet_name         = "lcl-green-svc-subnet"
  subnet_cidr_block   = "${var.svc_cidr_block}"
  vnet_name           = "${module.virtual_network.vnet_name}"
  nsg_id              = "${module.svc_subnet_nsg.nsg_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
}

module "gateway_subnet" {
  source = "../modules/subnet"

  subnet_name         = "lcl-green-gateway-subnet"
  subnet_cidr_block   = "${var.gateway_cidr_block}"
  vnet_name           = "${module.virtual_network.vnet_name}"
  nsg_id              = "${module.gateway_subnet_nsg.nsg_id}"
  resource_group_name = "${module.resource_group.resource_group_name}"
}

output "resource_group_name" {
  value = "${module.resource_group.resource_group_name}"
}

output "resource_group_id" {
  value = "${module.resource_group.resource_group_id}"
}
