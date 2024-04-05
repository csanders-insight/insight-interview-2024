
resource "azurerm_virtual_network" "mynetwork" {
  name                = random_id.random_id.dec
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  address_space       = ["10.0.0.0/16"]
}

# "namespace"
resource "azurerm_subnet" "mysubnet" {
  name                 = random_id.random_id.dec
  resource_group_name  = azurerm_resource_group.myresourcegroup.name
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Allow VMs to use the subnet
resource "azurerm_network_interface" "mynic" {
  count = var.num_instances

  name                = "${count.index}-${random_id.random_id.dec}"
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

  name                            = "${count.index}-${random_id.random_id.dec}"
  resource_group_name             = azurerm_resource_group.myresourcegroup.name
  location                        = azurerm_resource_group.myresourcegroup.location
  size                            = "Standard_B1s"
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