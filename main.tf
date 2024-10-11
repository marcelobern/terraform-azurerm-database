moved {
  from = azurerm_resource_group.rg
  to   = azurerm_resource_group.rg[0]
}

resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "27d30994-120c-4ff6-86e8-4dfc579824e3"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "rg"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

locals {
  resource_group_name = try(azurerm_resource_group.rg[0].name, var.resource_group_name)
  azuread_authentication_only = try(var.sql_aad_administrator.azuread_authentication_only, false)
}

resource "azurerm_mssql_database" "db" {
  name        = var.db_name
  server_id   = azurerm_mssql_server.server.id
  collation   = var.collation
  create_mode = "Default"
  sku_name    = var.db_sku_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "6b3e12da-f05f-4a96-8d66-df9dadb508c4"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "db"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_mssql_server" "server" {
  #checkov:skip=CKV2_AZURE_2:We don't change tf config for now
  #checkov:skip=CKV_AZURE_24:We don't change tf config for now
  #checkov:skip=CKV_AZURE_23:We don't change tf config for now
  #checkov:skip=CKV2_AZURE_6:We don't change tf config for now
  administrator_login          = local.azuread_authentication_only ? null : var.sql_admin_username
  administrator_login_password = local.azuread_authentication_only ? null : var.sql_password
  azuread_administrator        = var.sql_aad_administrator
  location                     = var.location
  name                         = "${var.db_name}-sqlsvr"
  resource_group_name          = local.resource_group_name
  version                      = var.server_version
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "9da1dcbc-184f-4e28-9f98-29d4cb57350e"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "server"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_mssql_firewall_rule" "fw" {
  #checkov:skip=CKV_AZURE_11:We don't change tf config for now
  end_ip_address   = var.end_ip_address
  name             = "${var.db_name}-fwrules"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = var.start_ip_address
}