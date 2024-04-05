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

resource "random_id" "random_id" {
  byte_length = 2
}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = random_id.random_id.dec
  location = "East US"
}

