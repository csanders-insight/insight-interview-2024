resource "azurerm_storage_account" "mystorage" {
  count                    = var.num_instances

  name                     = "${count.index}id${random_id.random_id.dec}"
  resource_group_name      = azurerm_resource_group.myresourcegroup.name
  location                 = azurerm_resource_group.myresourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}