# -------------------------------------------------------------------
#
# Module:         ScaleWeb
# Purpose:        Create a scaled webserver farm with a bastion
#                 server to enable connection to resources via ssh.
# Created on:     11 February 2018
# Created by:     David Sanders
# Creator email:  dsanderscanada@gmail.com 
# Repository:     https://github.com/dsandersAzure/tf-learning
#
# -------------------------------------------------------------------

# Create the resource group which will be used to contain
# all resources. The default name is held in variables.tf
# and can be overridden by passing -var resource_group_name=
#
resource "azurerm_resource_group" "vmss" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"

  tags {
    environment = "codelab"
  }
}

# Create the virtual network which will be used to contain
# all resources. The default name is held in variables.tf
# and can be overridden by passing -var azurerm_virtual_network=
#
# Notice the CIDR block is set to a default of 10.0.0.0/16 which
# is way too big.
#
resource "azurerm_virtual_network" "vmss" {
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"

  tags {
    environment = "codelab"
  }
}

# Create the subnet for resources (10.0.2.0/24). Typically,
# there would be more than one subnet to segregate traffic
# but in this example, only one is used.
#
resource "azurerm_subnet" "vmss" {
  name                 = "vmss-subnet"
  resource_group_name  = "${azurerm_resource_group.vmss.name}"
  virtual_network_name = "${azurerm_virtual_network.vmss.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a public IP for the load balancer and assign a static
# address.
#
resource "azurerm_public_ip" "vmss" {
  name                         = "vmss-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.vmss.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${azurerm_resource_group.vmss.name}"

  tags {
    environment = "codelab"
  }
}

# Create a load balancer and tell it to use the Public IP created
# above.
#
resource "azurerm_lb" "vmss" {
  name                = "vmss-lb"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.vmss.id}"
  }

  tags {
    environment = "codelab"
  }
}

# Create a backend address pool for resources being load balanced
# (e.g. VMs, etc.)
#
resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "BackEndAddressPool"
}

# Create a load balancer probe for health checking. In this case
# the probe checks against the application port (default 8080)
# to ensure resources being load balanced are healthy.
#
resource "azurerm_lb_probe" "vmss" {
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "ssh-running-probe"
  port                = "${var.application_port}"
}

# Create a NAT rule to allow the load balancer to pass traffic
# to the backend resources. In this case, take traffic on port
# 80 and pass it on to the application port (default 8080)
#
resource "azurerm_lb_rule" "lbnatrule" {
    resource_group_name            = "${azurerm_resource_group.vmss.name}"
    loadbalancer_id                = "${azurerm_lb.vmss.id}"
    name                           = "http"
    protocol                       = "Tcp"
    frontend_port                  = "80"
    backend_port                   = "${var.application_port}"
    backend_address_pool_id        = "${azurerm_lb_backend_address_pool.bpepool.id}"
    frontend_ip_configuration_name = "PublicIPAddress"
    probe_id                       = "${azurerm_lb_probe.vmss.id}"
}

# Create a Virtual Machine Scale Set (vmss). Use the vmss to set a
# scalable set of vm resources of a specific SKU (Standard_DS1_v2)
# which is relatively small and inexpensive. **NOTE** Not all
# Azure regions have the same resources; this means that changing
# the default location for this code from 'East US' to 'East US 2'
# *WILL* cause this terraform to fail.
#
resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  upgrade_policy_mode = "Manual"

  # Define the type of VM being created and the number of initial
  # VMs.
  #
  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
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
    lun          = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  # Configure each VM. Note that there is a hard-coded username and
  # password which is **BAD**. This could be okay if disable_password_
  # authentication in os_profile_linux_config is set to true and agent
  # forwarding is used from a jump box.
  #
  os_profile {
    computer_name_prefix = "vmlab"
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
  # authentication is set to false and in production this should
  # **ABSOLUTELY** be set to true. It was set to false because the
  # author had challenges with agent forwarding.
  #
  os_profile_linux_config {
    disable_password_authentication = false

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
      subnet_id                              = "${azurerm_subnet.vmss.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
    }
  }

  # extension enables Microsoft Azure extensions to be appliend to the
  # machine during instantiation. In the example below (commented out),
  # each instance in the scale set installs nginx.
  #
  extension { 
    name = "vmssextension"
    publisher = "Microsoft.OSTCExtensions"
    type = "CustomScriptForLinux"
    type_handler_version = "1.2"
#    settings = <<SETTINGS
#    {
#        "commandToExecute": "sudo apt-get -y install nginx"
#    }
#    SETTINGS
  }

  tags {
    environment = "codelab"
  }
}

# Create a Public IP that can be used for a jumpbox (or bastion) server
# to enable access to resources that are not exposed to the internet, e.g.
# the vmss and its instances.
#
resource "azurerm_public_ip" "jumpbox" {
  name                         = "jumpbox-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.vmss.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${azurerm_resource_group.vmss.name}-ssh"

  tags {
    environment = "codelab"
  }
}

# Create a network interface (there could be many of these) for the
# jumpbox and assign the public ip to it.
#
resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox-nic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"

  # Configure the interface to use the Public IP
  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${azurerm_subnet.vmss.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
  }

  tags {
    environment = "codelab"
  }
}

# Create a jumpbox to enable ssh into the environment. The scale set is only
# reachable from the internet through the load balancer (port 80) to the 
# application port (8080); therefore, to ssh into the environment we need
# the jumpbox or bastion.
#
resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "jumpbox"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.vmss.name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
  vm_size               = "Standard_DS1_v2"

  # Use Ubuntu as the server
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # Use managed disks
  storage_os_disk {
    name              = "jumpbox-osdisk"
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
    computer_name  = "jumpbox"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  # Configure the jumpbox to disable password auth and to use the default
  # public key (id_rsa.pub)
  #
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  tags {
    environment = "codelab"
  }
}
