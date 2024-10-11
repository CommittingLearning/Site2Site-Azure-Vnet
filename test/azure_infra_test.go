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

	// Ensure resources are cleaned up after tests complete
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Validate that the VNet has been created
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	assert.NotEmpty(t, vnetName, "VNet should have a valid name")
}
