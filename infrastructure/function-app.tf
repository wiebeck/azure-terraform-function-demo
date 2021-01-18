resource "azurerm_app_service_plan" "asp" {
  name                = "${var.prefix}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  // default is "Windows" operating system
  kind = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix}-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "java"
}

resource "azurerm_function_app" "func" {
  name                = "${var.prefix}-func"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~3"
  // TODO: How to set the Java runtime version?
  // the following was recommended on https://stackoverflow.com/a/64533932 but doesn't work: "The parameter LinuxFxVersion has an invalid value."
  // site_config {
  //   linux_fx_version = "11"
  // }
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "java"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.appinsights.instrumentation_key
    WEBSITE_RUN_FROM_PACKAGE       = "${azurerm_storage_blob.appcode.url}${data.azurerm_storage_account_sas.sas.sas}"
  }
}
