# Creating the vnet resource
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${var.environment}"
    address_space       = [var.address_space]
    location            = var.location
    resource_group_name = "${var.rg_name}_${var.environment}"
}

#Creating the vm subnet
resource "azurerm_subnet" "vm_subnet" {
    name                 = var.subnet1_name
    resource_group_name  = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet1_add_prefix]
}

# Creating the vpn gateway subnet
resource "azurerm_subnet" "vpn_gateway_subnet" {
    name                 = var.subnet2_name
    resource_group_name  = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet2_add_prefix]
}

# Creating the Bastion Subnet
resource "azurerm_subnet" "bastion_subnet" {
    name                 = var.subnet3_name
    resource_group_name  = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.subnet3_add_prefix]
}