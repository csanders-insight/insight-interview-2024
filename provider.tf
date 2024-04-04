terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = "resourcegroup-example"
  location = "East US"
}

# Virtual network
resource "azurerm_virtual_network" "mynetwork" {
  name                = "vnet-example"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = ["10.0.0.0/16"]
}

# Subdivision of network
resource "azurerm_subnet" "mysubnet" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "random_uuid" "random_uuid" {}

# Allow VMs to use the subnet
resource "azurerm_network_interface" "mynic" {
  count = var.num_instances

  name                = "${count.index}-${random_uuid.random_uuid.result}"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.mysubnet.id
  }
}

# Create the VMs
resource "azurerm_linux_virtual_machine" "myvm" {
  count = var.num_instances

  name                            = "${count.index}-${random_uuid.random_uuid.result}"
  resource_group_name             = azurerm_resource_group.myresourcegroup.name
  location                        = azurerm_resource_group.myresourcegroup.location
  size                            = "Standard_B2ats_v2"
  admin_username                  = "myadmin"
  admin_password                  = "Th1sIsF@ke"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.mynic[count.index].id
  ]
  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
