# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Code set:       vmss.tf
# Purpose:        Create a scaled webserver farm with a bastion
#                 server to enable connection to resources via ssh.
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Create a jumpbox to enable ssh into the environment. The scale set is only
# reachable from the internet through the load balancer (port 80) to the 
# application port (8080); therefore, to ssh into the environment we need
# the jumpbox or bastion.
#
variable "nic_id" {}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "vm_name" {}
variable "vm_os_name" {}

variable "vm_admin_user" {
  default = "azureuser"
}

variable "vm_admin_password" {
  default = "Password1234!"
}

variable "vm_disable_password_authentication" {
  default = true
}

variable "location" {}
variable "resource_prefix" {}
variable "resource_group_name" {}
variable "environment" {}

resource "azurerm_virtual_machine" "avm" {
  name                = "${var.vm_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  network_interface_ids = ["${var.nic_id}"]
  vm_size               = "${var.vm_size}"

  # Use Ubuntu as the server
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # Use managed disks
  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Define the properties of the jumpbox and a default username and
  # password; *NOTE* the username and password can **NEVER** be used
  # with ssh because we disable password authentication. The keys (see
  # below) are the only way to connect to the box.
  #
  os_profile {
    computer_name  = "${var.vm_os_name}"
    admin_username = "${var.vm_admin_user}"
    admin_password = "${var.vm_admin_password}"
  }

  # Configure the jumpbox to disable password auth and to use the default
  # public key (id_rsa.pub)
  #
  os_profile_linux_config {
    disable_password_authentication = "${var.vm_disable_password_authentication}"

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  tags {
    environment = "${var.environment}"
  }
}

output "vm_username" {
  value = "${var.vm_admin_user}"
}
