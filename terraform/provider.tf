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

resource "random_uuid" "random_uuid" {}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = random_uuid.random_uuid.result
  location = "East US"
}

resource "azurerm_virtual_network" "mynetwork" {
  name                = random_uuid.random_uuid.result
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = ["10.0.0.0/16"]
}

# Subdivision of network
# TODO: If we don't need this for other resources, move to vm.tf
resource "azurerm_subnet" "mysubnet" {
  name                 = random_uuid.random_uuid.result
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}


