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

# Allow VMs to use the subnet
resource "azurerm_network_interface" "mynic" {
  name                = "nic-example"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.mysubnet.id
  }
}

# Create the VM
resource "azurerm_linux_virtual_machine" "myvm" {
  name                = "my-new-guy"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  size                = "B"
  admin_username      = "myadmin"
  network_interface_ids = [
    azurerm_network_interface.mynic.id
  ]
  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }
}
