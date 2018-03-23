resource "azurerm_virtual_network" "vnet" {
    name                = "${var.pri_sec}-${var.org_tla}-${var.stage}-vnet-${var.vnet_name}"
    address_space       = ["${var.cidr_block}"]
    location            = "${var.location}"
    resource_group_name = "${var.rg_name}"

    tags {
        location = "${var.location}"
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
    }
}