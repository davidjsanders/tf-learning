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
    value = "${module.pip.ip_fqdn}"
}

# The public ip assigned to the jumpbox (or bastion)
output "jumpbox_public_ip" {
    value = "${module.jumpbox_pip.ip_fqdn}"
}

output "vm_username" { value = "${module.jumpbox_vm.vm_username}" }
