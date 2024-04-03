locals {
  my_rg = "/subscriptions/8efb9868-b245-4c5a-bfa5-395b4088d937/resourceGroups/resourcegroup-example"
}

locals {
  my_vnet = "${local.my_rg}/providers/Microsoft.Network/virtualNetworks/vnet-example"
}

import {
  id = local.my_rg
  to = azurerm_resource_group.myresourcegroup
}

import {
  id = local.my_vnet
  to = azurerm_virtual_network.mynetwork
}

import {
  id = "${local.my_vnet}/subnets/subnet-example"
  to = azurerm_subnet.mysubnet
}

import {
  id = "${local.my_rg}/providers/Microsoft.Network/networkInterfaces/nic-example"
  to = azurerm_network_interface.mynic
}