resource "azurerm_virtual_network" "vnet" {
    name = "vnet_${var.environment}"
    address_space = var.address_space
    location = var.location
    resource_group_name = "${var.rg_name}_${environment}"
}

resource "azurerm_subnet" "vm_subnet" {
    name = var.subnet1_name
    resource_group_name = "${var.rg_name}_${environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet1_add_prefix
}

resource "azurerm_subnet" "vpn_gateway_subnet" {
    name = var.subnet2_name
    resource_group_name = "${var.rg_name}_${environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet2_add_prefix
}