# -------------------------------------------------------------------
#
# Module:         sample-app
# Submodule:      dev
# Code set:       main.tf
# Purpose:        
# Created on:     
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Configure the Azure Provider
provider "azurerm" {}

module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.azure_location}"
  environment         = "${var.tag_environment}"
  name                = "${var.tag_name}"
}

#module "vnet" {
#  source = "../modules/vnet"
#  resource_prefix = "${var.resource_prefix}"
#  resource_group_name = "${module.resource_group.resource_group_name}"
#  location = "${var.azure_location}"
#  environment = "${var.tag_environment}"
#  name = "${var.tag_name}"
#  cidr_block = "10.0.0.0/20"
#}
module "nsg" {
  source              = "../modules/nsg"
  resource_prefix     = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  nsg_name            = "${var.nsg_name}"
  location            = "${var.azure_location}"
}

module "subnet" {
  source              = "../modules/subnet"
  resource_prefix     = "${var.resource_prefix}"
  resource_group_name = "${var.vnet_group}"
  vnet_name           = "${var.vnet_name}"
  nsg_id              = "${module.nsg.nsg_id}"
  subnet_cidr_block   = "${var.subnet_cidr_block}"
}

module "vm1-nic" {
  source              = "../modules/nic"
  resource_prefix     = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  subnet_id           = "${module.subnet.subnet_id}"
  name                = "vm-ubuntu-1"
  location            = "${var.azure_location}"
  environment         = "${var.tag_environment}"
}

module "vm1" {
  source              = "../modules/ubuntu-vm"
  resource_prefix     = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  vm_name             = "vm-ubuntu-1"
  nic_id              = "${module.vm1-nic.id}"
  location            = "${var.azure_location}"
  environment         = "${var.tag_environment}"
  vm_os_name          = "vm-ubuntu-1"
}
