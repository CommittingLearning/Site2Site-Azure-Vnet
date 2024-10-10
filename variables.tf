variable "azure_subscription_id" {
    description = "The Subscription ID for the Azure account"
    type        = string
}

variable "azure_client_id" {
    description = "The Client ID (App ID) for the Azure Service Principal"
    type        = string 
}

variable "azure_client_secret" {
    description = "The Client Secret for the Azure Service Principal"
    type        = string
    sensitive   = true
}

variable "azure_tenant_id" {
    description = "The Tenant ID for the Azure account"
    type        = string
}

variable "rg_name" {
    description = "Name of the Resource Group"
    default     = "Site2Site_rg"
}

variable "location" {
    description = "Region of Deployment"
    default     = "West US"
}

variable "environment" {
    description = "The environment (e.g., development, production) to append to the VNet name"
    type        = string

    validation {
      condition = contains(["development", "production"], var.environment)
      error_message = "Environment must be either 'development' or 'production'."
    }
}

variable "address_space" {
    description = "IP Address space assigned to the VNet"
    default     = ["10.0.0.0/16"]
}

variable "subnet1_name" {
    description = "Name of the subnet where the VM will be provisioned"
    default     = "vm-subnet"
}

variable "subnet1_add_prefix" {
    description = "IP range of the vm subnet"
    default     = ["10.0.1.0/24"]
}

variable "subnet2_name" {
    description = "name of the subnet where the VPN Gateway will be provisioned"
    default     = "GatewaySubnet"
}

variable "subnet2_add_prefix" {
    description = "IP range of the gateway subnet"
    default     = ["10.0.2.0/24"]
}