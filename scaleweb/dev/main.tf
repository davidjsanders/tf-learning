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
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
  cidr_block = "10.0.0.0/20"
}

module "subnet" {
  source = "../modules/subnet"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${var.resource_group_name}"
  vnet_name = "${module.vnet.vnet_name}"
  subnet_cidr_block = "10.0.2.0/24"
}

module "pip" {
  source = "../modules/publicip"
  pip_name = "load_balancer_pip"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "lb" {
  source = "../modules/loadbal"
  public_ip_id = "${module.pip.ip_id}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "bepool" {
  source = "../modules/bepool"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  loadbalancer_id = "${module.lb.lb_id}"
}

module "lbprobe" {
  source = "../modules/lbprobe"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  loadbalancer_id = "${module.lb.lb_id}"
  port = "${var.application_port}"
}

module "lbrule" {
  source = "../modules/lbrule"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  loadbalancer_id = "${module.lb.lb_id}"
  frontend_port = "80"
  application_port = "${var.application_port}"
  be_address_pool_id = "${module.bepool.be_pool_id}"
  lb_fe_config_name = "${module.lb.lb_fe_config_name}"
  lb_probe_id = "${module.lbprobe.lb_probe_id}"
  lb_name = "http"
  lb_protocol = "Tcp"
}