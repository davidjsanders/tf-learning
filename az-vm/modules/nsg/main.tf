resource "azurerm_network_security_group" "netsecgroup" {
  name                = "${var.org_tla}${var.stage}${var.nsg_name}NSG"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
}
