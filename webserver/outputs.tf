# Outputs
output "webserver_port" {
  value = "${var.ws-server-port}"
}

output "public_ip" {
  value = "${azurerm_public_ip.ws-pip.ip_address}"
}

output "curl_to" {
  value = "${azurerm_public_ip.ws-pip.ip_address}:${var.ws-server-port}"
}
