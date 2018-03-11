# Create the subnet for resources (10.0.2.0/24). Typically,
# there would be more than one subnet to segregate traffic
# but in this example, only one is used.
#
resource "azurerm_subnet" "subnet" {
  name                = "${var.vnet_name}-${var.subnet_name}"
  resource_group_name  = "${var.rg_name}"
  virtual_network_name = "${var.vnet_name}"
  address_prefix       = "${var.subnet_cidr_block}"
}