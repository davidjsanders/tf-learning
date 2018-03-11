# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.org_tla}-${var.stage}-rg-${var.name}"
  location = "${var.location}"

  tags {
    description = "${var.description}"
    environment = "${var.stage}"
    organization = "${var.org_tla}"
    billing = "${var.billing_code}"
  }
}

