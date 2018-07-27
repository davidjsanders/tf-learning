# -------------------------------------------------------------------
#
# Module:         acsk8s
# Submodule:      dev
# Code set:       main.tf
# Purpose:        Deploy the Azure Container Services kubernetes (k8s)
#                 infrastructure for a small unmanaged cluster.
# Created on:     18 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Configure the Azure Provider
provider "azurerm" {}

module "acs_rg" {
  source              = "../modules/rg"
  tag_environment     = "${var.tag_environment}"
  tag_description     = "${var.tag_description}"
  tag_orchestrator    = "${var.tag_orchestrator}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  resource_prefix     = "${var.resource_prefix}"
}

module "acs_svc" {
  source                          = "../modules/acs"
  tag_environment                 = "${var.tag_environment}"
  tag_description                 = "${var.tag_description}"
  tag_orchestrator                = "${var.tag_orchestrator}"
  resource_group_name             = "${module.acs_rg.name}"
  location                        = "${var.location}"
  resource_prefix                 = "${var.resource_prefix}"
  service_principal_client_id     = "${var.client_id}"
  service_principal_client_secret = "${var.client_secret}"
  agent_sku                       = "${var.agent_sku}"
  master_count                    = "${var.master_count}"
  agent_count                     = "${var.agent_count}"
  linux_user                      = "${var.linux_user}"
}
