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

# Create a backend address pool for resources being load balanced
# (e.g. VMs, etc.)
#
# Create a Virtual Machine Scale Set (vmss). Use the vmss to set a
# scalable set of vm resources of a specific SKU (Standard_DS1_v2)
# which is relatively small and inexpensive. **NOTE** Not all
# Azure regions have the same resources; this means that changing
# the default location for this code from 'East US' to 'East US 2'
# *WILL* cause this terraform to fail.
#
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.scaleset_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  upgrade_policy_mode = "${var.upgrade_policy_mode}"

  # Define the type of VM being created and the number of initial
  # VMs.
  #
  sku {
    name     = "${var.sku_name}"
    tier     = "${var.sku_tier}"
    capacity = "${var.sku_qty}"
  }

  # Set the image information for each VM, in this case Ubuntu.
  #
  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # Use managed disks
  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Use managed disks
  storage_profile_data_disk {
    lun            = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = "${var.data_disk_size_gb}"
#    disk_size_gb   = 10
  }

  # Configure each VM. Note that there is a hard-coded username and
  # password which is **BAD**. This could be okay if disable_password_
  # authentication in os_profile_linux_config is set to true and agent
  # forwarding is used from a jump box.
  #
  os_profile {
    computer_name_prefix = "${var.instance_name_prefix}"
    admin_username       = "azureuser"
    admin_password       = "Password1234!"
    # Custom data specifies a set of instructions which the machine
    # will execute on instantiation. **NOTE** This configuration is
    # *ONLY* applied when the machine is instantiated and changing
    # it will **NOT** cause terraform to reapply the configuration.
    # In production scenarios, this is more likely to install Chef,
    # puppet, etc., agents.
    #
    custom_data = <<-EOF
      #!/bin/bash
      echo "Response from: $HOSTNAME" > index.html
      nohup busybox httpd -f -p "${var.application_port}" &
      EOF
  }

  # This section configures Linux. Note that disable password
  # authentication is set to true.
  #
  os_profile_linux_config {
    disable_password_authentication = true

    # The ssh keys are copied from the default key (id_rsa). One
    # thing to note is that ~/.ssh/known_hosts will record the
    # host details and that if you are tearing environments up
    # and down you either need to edit the known_hosts file or
    # specify to ssh not to host verify.
    #
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  # Define the network profile of the vmss.
  #
  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${var.bepool_id}"]
    }
  }

  tags {
    environment = "${var.environment}"
    name = "${var.name}"
  }
}
