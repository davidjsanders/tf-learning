resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_prefix}-${var.resource_group_name}"
  location = "${var.location}"

  tags {
    description = "${var.tag_description}"
    env = "${var.tag_environment}"
    prefix = "${var.resource_prefix}"
    orchestrator = "${var.tag_orchestrator}"
  }
}
