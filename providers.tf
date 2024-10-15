provider "azurerm" {
    features {}

    subscription_id = var.azure_subscription_id
    client_id       = var.azure_client_id
    tenant_id       = var.azure_tenant_id
}

terraform {
  backend "azurerm" {
    resource_group_name   = "Site2Site_rg_development"
    storage_account_name  = "tsblobstore11development"
    container_name        = "terraform-state"
    key                   = "Site2Site_VPC_development.tfstate"
    use_oidc              = true
  }
}