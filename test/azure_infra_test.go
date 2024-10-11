package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureInfra(t *testing.T) {
	// Read Azure credentials from environment variables
	azureSubscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")
	azureClientID := os.Getenv("AZURE_CLIENT_ID")
	azureTenantID := os.Getenv("AZURE_TENANT_ID")
	environment := os.Getenv("ENVIRONMENT")

	// Define Terraform options and pass the variables here
	terraformOptions := &terraform.Options{
		// Path to the Terraform code that deploys the infrastructure
		TerraformDir: "../",

		// Pass the required variables for Terraform
		Vars: map[string]interface{}{
			"azure_subscription_id": azureSubscriptionID,
			"azure_client_id":       azureClientID,
			"azure_tenant_id":       azureTenantID,
			"environment":           environment,
		},
	}

	// Run `terraform init` and `terraform plan` to check the infrastructure before applying changes
	terraform.InitAndPlan(t, terraformOptions)

	// Validate that the VNet name contains the environment variable
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	assert.Contains(t, vnetName, environment, "VNet name should include the environment")

	// Validate the VNet address space is 10.0.0.0/16
	vnetAddressSpace := terraform.Output(t, terraformOptions, "vnet_address_space")
	assert.Equal(t, "10.0.0.0/16", vnetAddressSpace, "VNet address space should be 10.0.0.0/16")

	// Validate that there are two subnets being created
	subnetCount := terraform.OutputList(t, terraformOptions, "subnets")
	assert.Equal(t, 2, len(subnetCount), "There should be exactly two subnets created")
}
