# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Submodule:      dev
# Code set:       main.tf
# Purpose:        Deploy the ScaleWeb example to a dev environment.
#                 The dev environment is scaled to specific resources
#                 and sizes required for devs and cannot be exceeded
#                 (e.g. by specifying larger machine sizes or counts)
# Created on:     17 February 2018
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
  pip_name = "load_balancer"
  domain_name = "web-${var.resource_group_name}"
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

module "scaleset" {
  source = "../modules/scaleset"
  lb_rule_name = "${module.lbrule.lb_rule_name}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  scaleset_name = "${var.resource_prefix}-scale-set"
  bepool_id = "${module.bepool.be_pool_id}"
  subnet_id = "${module.subnet.subnet_id}"
  application_port = "${var.application_port}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "jumpbox_pip" {
  source = "../modules/publicip"
  pip_name = "jumpbox"
  domain_name = "jumpbox-${var.resource_group_name}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "jumpbox_net_if" {
  source = "../modules/netifpub"
  if_name = "jumpbox"
  ip_public_id = "${module.jumpbox_pip.ip_id}"
  subnet_id = "${module.subnet.subnet_id}"
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}

module "jumpbox_vm" {
  source = "../modules/jumpbox"
  ip_id = "${module.jumpbox_net_if.netif_id}"
  vm_name = "jumpbox"
  vm_os_name = "jumpbox"
  vm_size = "Standard_DS1_v2"
  vm_disable_password_authentication = true
  resource_prefix = "${var.resource_prefix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  location = "${var.azure_location}"
  environment = "${var.tag_environment}"
  name = "${var.tag_name}"
}
