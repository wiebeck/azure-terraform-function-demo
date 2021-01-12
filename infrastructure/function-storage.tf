/*
 * Defines the storage where the function expects its deployments to be found.
 */
resource "azurerm_storage_account" "storage" {
  name = random_string.storage_name.result
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "deployments" {
  name = "function-releases"
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = "private"
}

/*
 * Uploads the function deployment as zip file.
 */
resource "azurerm_storage_blob" "appcode" {
  // can be any name...
  name = "deployment.zip"
  storage_account_name = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.deployments.name
  type = "Block"
  source = var.function_deployment
  // upload whenever the MD5 checksum of the file changes, otherwise the file
  // won't be uploaded if it already exists, even if it was changed.
  content_md5 = filemd5(var.function_deployment)
}

// provides access to the uploaded zip file
data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.storage.primary_connection_string
  https_only        = false
  resource_types {
    service   = false
    container = false
    object    = true
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  start  = "2018-03-21"
  expiry = "2028-03-21"
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}
