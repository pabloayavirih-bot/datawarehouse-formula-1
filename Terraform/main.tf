
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# ==================================================
# VARIABLES
# ==================================================

variable "sql_admin_password" {
  description = "Contrasena del administrador SQL"
  type        = string
  sensitive   = true
}

locals {
  location = "brazilsouth"

  raw_files = fileset("${path.module}/../Dataset", "*.csv")
}

# ==================================================
# 1. GRUPO DE RECURSOS
# ==================================================

resource "azurerm_resource_group" "rg" {
  name     = "rg-formula1"
  location = local.location
}

# ==================================================
# 2. CUENTA DE ALMACENAMIENTO
# ==================================================

resource "azurerm_storage_account" "storage" {
  name                            = "stformula1jpah"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
}

# ==================================================
# 3. CONTENEDOR RAW
# ==================================================

resource "azurerm_storage_container" "raw" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# ==================================================
# 4. CARGA AUTOMATICA DE ARCHIVOS CSV
# ==================================================

resource "azurerm_storage_blob" "raw_files" {
  for_each = local.raw_files

  name                   = each.value
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.raw.name
  type                   = "Block"

  source       = "${path.module}/../Dataset/${each.value}"
  content_md5  = filemd5("${path.module}/../Dataset/${each.value}")
  content_type = "text/csv"
}

# ==================================================
# 5. SERVIDOR AZURE SQL
# ==================================================

resource "azurerm_mssql_server" "sql_server" {
  name                          = "sql-formula1-jpah"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = "adminformula1"
  administrator_login_password  = var.sql_admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
}

# ==================================================
# 6. FIREWALL PARA SERVICIOS AZURE
# ==================================================

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# ==================================================
# 7. BASE DE DATOS DATA WAREHOUSE
# ==================================================

resource "azurerm_mssql_database" "dw" {
  name        = "dw_formula_1"
  server_id   = azurerm_mssql_server.sql_server.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "Basic"
  max_size_gb = 2
}

# ==================================================
# 8. AZURE DATA FACTORY
# ==================================================

resource "azurerm_data_factory" "adf" {
  name                = "adf-formula1-jpah"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }
}

# ==================================================
# 9. SALIDAS
# ==================================================

output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "storage_account" {
  value = azurerm_storage_account.storage.name
}

output "raw_container" {
  value = azurerm_storage_container.raw.name
}

output "raw_files_count" {
  value = length(local.raw_files)
}

output "sql_server" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "database_name" {
  value = azurerm_mssql_database.dw.name
}

output "data_factory_name" {
  value = azurerm_data_factory.adf.name
}
