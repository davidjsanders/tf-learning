provider "azurerm" {
    #
}

module "resource_group" {
    source = "../modules/rg"

    name = "${var.name}"
    location  = "${var.location}"
    org_tla = "${var.org_tla}"
    stage = "${var.stage}"
    description = "${var.description}"
    billing_code = "${var.billing_code}"
}

module "pip" {
    source = "../modules/publicIP"
    pip_name = "${var.pip_name}"
    pip_allocation = "${var.pip_allocation}"
    pip_domain = "${var.pip_domain}"
    rg_name = "${module.resource_group.resource_group_name}"
    org_tla = "${var.org_tla}"
    stage = "${var.stage}"
    location  = "${var.location}"
    description = "${var.description}"
    billing_code = "${var.billing_code}"
}

module "nsg" {
    source = "../modules/nsg"
    nsg_name = "${var.nsg_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    org_tla = "${var.org_tla}"
    stage = "${var.stage}"
    location  = "${var.location}"
}

module "nsg_rule_ssh_bastion" {
    source = "../modules/nsgRule"

    nsg_name = "${module.nsg.nsg_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    rule_name = "allowPort22ToBastion"
    rule_priority = 1000
    rule_direction = "Inbound"
    rule_access = "allow"
    rule_protocol = "Tcp"
    rule_source_port = "22"
    rule_source_address_prefix = "*"
    rule_dest_port = "22"
    rule_dest_address_prefix = "10.0.1.0/24"
}

module "nsg_rule_ssh_from_bastion" {
    source = "../modules/nsgRule"

    nsg_name = "${module.nsg.nsg_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    rule_name = "allowPort22ToWebServers"
    rule_priority = 1010
    rule_direction = "Inbound"
    rule_access = "allow"
    rule_protocol = "Tcp"
    rule_source_port = "22"
    rule_source_address_prefix = "10.0.1.0/24"
    rule_dest_port = "22"
    rule_dest_address_prefix = "*"
}

module "nsg_rule_deny_all_inbound" {
    source = "../modules/nsgRule"

    nsg_name = "${module.nsg.nsg_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    rule_name = "denyPort22"
    rule_priority = 1020
    rule_direction = "Inbound"
    rule_access = "deny"
    rule_protocol = "Tcp"
    rule_source_port = "*"
    rule_source_address_prefix = "*"
    rule_dest_port = "*"
    rule_dest_address_prefix = "*"
}

module "virtual_network" {
    source = "../modules/vnet"

    vnet_name = "${var.vnet_name}"
    cidr_block = "${var.vnet_cidr_block}"
    rg_name = "${module.resource_group.resource_group_name}"
    name = "${var.name}"
    location  = "${var.location}"
    org_tla = "${var.org_tla}"
    stage = "${var.stage}"
    description = "${var.description}"
    billing_code = "${var.billing_code}"
}

module "vnet_subnet_bastion" {
    source = "../modules/subnet"

    vnet_name = "${module.virtual_network.vnet_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    subnet_name = "${var.subnet_bastion_name}"
    subnet_cidr_block = "${var.subnet_bastion_cidr_block}"
}

module "vnet_subnet_frontend" {
    source = "../modules/subnet"

    vnet_name = "${module.virtual_network.vnet_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    subnet_name = "${var.subnet_fe_name}"
    subnet_cidr_block = "${var.subnet_fe_cidr_block}"
}

module "vnet_subnet_backend" {
    source = "../modules/subnet"

    vnet_name = "${module.virtual_network.vnet_name}"
    rg_name = "${module.resource_group.resource_group_name}"
    subnet_name = "${var.subnet_be_name}"
    subnet_cidr_block = "${var.subnet_be_cidr_block}"
}

output "resource_group_name" {
    value = "${module.resource_group.resource_group_name}"
}