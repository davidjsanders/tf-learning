provider "azurerm" {}

resource "azurerm_resource_group" "mgt_resource_group" {
    name     = "${var.org_tla}-${var.stage}-rg-${var.app_name}-mgt"
    location = "${var.mgt_region}"

    tags {
        location = "${var.mgt_region}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}

resource "azurerm_resource_group" "resource_group" {
    count = "${var.ha_zones}"
    name     = "${var.org_tla}-${var.stage}-rg-${var.app_name}-${element(var.group_names, count.index)}"
    location = "${element(var.regions, count.index)}"

    tags {
        location = "${element(var.regions, count.index)}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}

resource "azurerm_virtual_network" "mgt_vnet" {
    name                = "${var.org_tla}-${var.stage}-vnet-${var.app_name}-mgt"
    address_space       = ["${var.mgt_cidr}"]
    location            = "${var.mgt_region}"
    resource_group_name = "${azurerm_resource_group.mgt_resource_group.name}"

    tags {
        location = "${var.mgt_region}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}

resource "azurerm_virtual_network" "vnet" {
    count = "${var.ha_zones}"
    name                = "${var.org_tla}-${var.stage}-vnet-${var.app_name}-${element(var.group_names, count.index)}"
    address_space       = ["${element(var.cidr_blocks, count.index)}"]
    location            = "${element(var.regions, count.index)}"
    resource_group_name = "${element(azurerm_resource_group.resource_group.*.name, count.index)}"

    tags {
        location = "${element(var.regions, count.index)}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}

resource "azurerm_subnet" "mgt_subnet" {
    name                = "mgt-${var.org_tla}-${var.stage}-subnet-mgt"
    resource_group_name  = "${azurerm_resource_group.mgt_resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.mgt_vnet.name}"
    address_prefix       = "${var.mgt_subnet_cidr}"
}

resource "azurerm_subnet" "subnet_mgt" {
    count = "${var.ha_zones}"
    name                = "${element(var.group_names, count.index)}-${var.org_tla}-${var.stage}-subnet-mgt"
    resource_group_name  = "${element(azurerm_resource_group.resource_group.*.name, count.index)}"
    virtual_network_name = "${element(azurerm_virtual_network.vnet.*.name, count.index)}"
    address_prefix       = "${element(var.subnet_mgt_cidr_blocks, count.index)}"
}

resource "azurerm_subnet" "subnet_fe" {
    count = "${var.ha_zones}"
    name                = "${element(var.group_names, count.index)}-${var.org_tla}-${var.stage}-subnet-fe"
    resource_group_name  = "${element(azurerm_resource_group.resource_group.*.name, count.index)}"
    virtual_network_name = "${element(azurerm_virtual_network.vnet.*.name, count.index)}"
    address_prefix       = "${element(var.subnet_fe_cidr_blocks, count.index)}"
}

resource "azurerm_subnet" "subnet_be" {
    count = "${var.ha_zones}"
    name                = "${element(var.group_names, count.index)}-${var.org_tla}-${var.stage}-subnet-be"
    resource_group_name  = "${element(azurerm_resource_group.resource_group.*.name, count.index)}"
    virtual_network_name = "${element(azurerm_virtual_network.vnet.*.name, count.index)}"
    address_prefix       = "${element(var.subnet_be_cidr_blocks, count.index)}"
}

resource "azurerm_availability_set" "as_fe" {
    count = "${var.ha_zones}"
    name                 = "${element(var.group_names, count.index)}-${var.org_tla}-${var.stage}-as-fe"
    resource_group_name  = "${element(azurerm_resource_group.resource_group.*.name, count.index)}"
    location             = "${element(var.regions, count.index)}"

    tags {
        location = "${var.mgt_region}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}

