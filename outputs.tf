output "vnet_name" {
    description = "The name of the Virtual Network created"
    value       = azurerm_virtual_network.vnet.name
}

output "subnetVM_name" {
    description = "The name of the Subnet created for the VM"
    value       = azurerm_subnet.vm_subnet.name
}

output "subnetgateway_name" {
    description = "The name of the Subnet created for the VPN Gateway"
    value       = azurerm_subnet.vpn_gateway_subnet.name
}

output "subnetbastion_name" {
  description = "The name of the Subnet created for Bastion"
  value       = azurerm_subnet.bastion_subnet.name
}