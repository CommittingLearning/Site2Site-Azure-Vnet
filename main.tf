# Creating the vnet resource
resource "azurerm_virtual_network" "vnet" {
    name = "vnet_${var.environment}"
    address_space = [var.address_space]
    location = var.location
    resource_group_name = "${var.rg_name}_${var.environment}"
}

#Creating the vm subnet
resource "azurerm_subnet" "vm_subnet" {
    name = var.subnet1_name
    resource_group_name = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet1_add_prefix]
}

# Creating the vpn gateway subnet
resource "azurerm_subnet" "vpn_gateway_subnet" {
    name = var.subnet2_name
    resource_group_name = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet2_add_prefix]
}

# Creating the Bastion Subnet
resource "azurerm_subnet" "bastion_subnet" {
    name = var.subnet3_name
    resource_group_name = "${var.rg_name}_${var.environment}"
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [var.subnet3_add_prefix]
}

# NSG for VM Subnet
resource "azurerm_network_security_group" "vm_nsg" {
    name = "vm_nsg_${var.environment}"
    location = var.location
    resource_group_name = "${var.rg_name}_${var.environment}"

    # Allow RDP only from the Bastion subnet
    security_rule {
        name                        = "AllowRDPFromBastion"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "3389"
        source_address_prefix       = var.subnet3_add_prefix
        destination_address_prefix  = var.subnet1_add_prefix
    }

    # Allow data exchange with Gateway Subnet
    security_rule {
        name                        = "AllowGatewayTraffic"
        priority                    = 200
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "*"
        source_port_range           = "*"
        destination_port_range      = "*"
        source_address_prefix       = var.subnet2_add_prefix
        destination_address_prefix  = var.subnet1_add_prefix
    }
}

# Associate NSG with VM subnet
resource "azurerm_subnet_network_security_group_association" "vm_nsg_association" {
    subnet_id                   = azurerm_subnet.vm_subnet.id
    network_security_group_id   = azurerm_network_security_group.vm_nsg.id
}

# NSG for Bastion Subnet
resource "azurerm_network_security_group" "bastion_nsg" {
    name                = "bastion_nsg_${var.environment}"
    location            = var.location
    resource_group_name = "${var.rg_name}_${var.environment}"

    # Allow inbound RDP only from public IP
    security_rule {
        name                        = "AllowRDPFromPublicIP"
        priority                    = 100
        direction                   = "Inbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "3389"
        source_address_prefix       = "98.247.36.44"
        destination_address_prefix  = var.subnet3_add_prefix
    }

    # Allow RDP oubound to VM Subnet
    security_rule {
        name                        = "AllowRDPtoVM"
        priority                    = 200
        direction                   = "Outbound"
        access                      = "Allow"
        protocol                    = "Tcp"
        source_port_range           = "*"
        destination_port_range      = "3389"
        source_address_prefix       = var.subnet3_add_prefix
        destination_address_prefix  = var.subnet1_add_prefix
    }
}

# Associate NSG with Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "bastion_nsg_association" {
    subnet_id                 = azurerm_subnet.bastion_subnet.id
    network_security_group_id = azurerm_network_security_group.bastion_nsg.id
}