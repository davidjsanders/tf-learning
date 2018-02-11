# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       output.tf
# Purpose:        Define the outputs to be returned to the originator
#                 from the terraform execution.
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# The public ip assigned to the VM Scale Set
output "vmss_public_ip" {
    value = "${azurerm_public_ip.vmss.fqdn}"
}

# The public ip assigned to the jumpbox (or bastion)
output "jumpbox_public_ip" {
    value = "${azurerm_public_ip.jumpbox.fqdn}"
}
