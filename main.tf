resource "azurerm_resource_group" "rg" {
    name = var.rg_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet_${var.environment}"
    address_space = var.address_space
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "vm_subnet" {
    name = var.subnet1_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet1_add_prefix
}

resource "azurerm_subnet" "vpn_gateway_subnet" {
    name = var.subnet2_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet2_add_prefix
}