resource "azurerm_public_ip" "publicIP" {
  name                         = "${var.org_tla}-${var.stage}-pip-${var.pip_name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg_name}"
  public_ip_address_allocation = "${var.pip_allocation}"
  domain_name_label            = "${var.pip_domain}"

  tags {
        description = "${var.description}"
        environment = "${var.stage}"
        organization = "${var.org_tla}"
        billing = "${var.billing_code}"
  }
}
