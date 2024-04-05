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

resource "azurerm_virtual_network" "mynetwork" {
  name                = "vnet-example"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = ["10.0.0.0/16"]
}

# Subdivision of network
# TODO: for vms, do we need this for others?
resource "azurerm_subnet" "mysubnet" {
  name                 = "subnet-example"
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}


