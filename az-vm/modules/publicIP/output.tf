output "ip_id" {
  value = "${azurerm_public_ip.publicIP.id}"
}

output "ip_fqdn" {
  value = "${azurerm_public_ip.publicIP.fqdn}"
}
