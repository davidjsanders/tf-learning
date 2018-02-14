# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       main.tf
# Purpose:        Initialize terraform to use azure resource manager
#                 provider
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Configure the Azure Provider
provider "azurerm" { }

module "resource_group" {
  source = "../modules/resource_group"
  resource_group_name = "${var.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "vnet" {
  source = "../modules/vnet"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
  cidr_block = "10.0.0.0/20"
}

module "subnet" {
  source = "../modules/subnet"
  resource_group_name = "${var.resource_group_name}"
  vnet_name = "${module.vnet.vnet_name}"
  subnet_cidr_block = "10.0.2.0/24"
}

module "pip" {
  source = "../modules/publicip"
  pip_name = "load_balancer_pip"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}
