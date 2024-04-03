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
  name     = "interview-example"
  location = "East US"
}

# Enable VM to connect to internet, Azure, etc.
resource "azurerm_network_interface" "mynic" {
  name                = "nic-example"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
  }
}

# Create the VM
resource "azurerm_linux_virtual_machine" "vms" {
  name                  = "my-new-guy"
  resource_group_name   = azurerm_resource_group.myresourcegroup.name
  location              = azurerm_resource_group.myresourcegroup.location
  size                  = "B"
  admin_username        = "myadmin"
  network_interface_ids = [
    azurerm_network_interface.mynic.id
  ]
  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }
}
