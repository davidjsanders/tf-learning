output "rgs" {
    value = "${azurerm_resource_group.resource_group.*.name}"
}