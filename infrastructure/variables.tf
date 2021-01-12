// resources get prefixed with this
variable "prefix" {
  type = string
  default = "owtest"
}

// common location for all resources
variable "location" {
  type = string
  default = "germanywestcentral"
}

// the resource group name gets this as suffix
variable "environment" {
  type = string
  default = "dev"
}

// where to find the function zip deployment after ./gradlew azureFunctionsPackageZip
variable "function_deployment" {
  type = string
  default = "../build/azure-functions/myfunc.zip"
}

// the storage account resource gets a random name (needs to be unique across Azure)
resource "random_string" "storage_name" {
  length = 24
  upper = false
  lower = true
  number = true
  special = false
}
