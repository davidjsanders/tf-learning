# Configure the Azure Provider
provider "azurerm" { }

# Create a resource group
resource "azurerm_resource_group" "ws-rg" {
  name     = "dev-ws-rg-east-us-2"
  location = "East US 2"
  tags {
    environment = "dev"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "ws-vnet" {
  name                = "ws-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US 2"
  resource_group_name = "${azurerm_resource_group.ws-rg.name}"
  tags {
    environment = "dev"
  }
}

# Create subnet
resource "azurerm_subnet" "ws-subnet" {
  name                 = "ws-vnet-subnet-1"
  resource_group_name  = "${azurerm_resource_group.ws-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.ws-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "ws-pip" {
  name                         = "ws-pip"
  location                     = "East US 2"
  resource_group_name          = "${azurerm_resource_group.ws-rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "dev"
  }
}

resource "azurerm_network_security_group" "ws-nsg" {
  name                = "ws-nsg"
  location            = "East US 2"
  resource_group_name = "${azurerm_resource_group.ws-rg.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "${var.ws-server-port}"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "${var.ws-server-port}"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "ws-vm-if0" {
  name                = "ws-vm-if0"
  location            = "East US 2"
  resource_group_name = "${azurerm_resource_group.ws-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.ws-nsg.id}"

  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = "${azurerm_subnet.ws-subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ws-pip.id}"
  }
}

resource "azurerm_managed_disk" "ws-disk" {
  name                 = "ws-datadisk"
  location             = "East US 2"
  resource_group_name  = "${azurerm_resource_group.ws-rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "ws-server" {
  name                = "ws-server"
  location            = "East US 2"
  resource_group_name = "${azurerm_resource_group.ws-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ws-vm-if0.id}"]
  vm_size             = "Standard_D1"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "ws-dev"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    custom_data = <<-EOF
      #!/bin/bash
      echo "Hello, World" > index.html
      nohup busybox httpd -f -p "${var.ws-server-port}" &
      EOF
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "dev"
  }
}
