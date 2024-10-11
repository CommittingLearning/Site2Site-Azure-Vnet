package test

import (
	"encoding/json"
	"os"
	"strings"
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

	// Run `terraform init` and `terraform plan`
	terraform.InitAndPlan(t, terraformOptions)

	// Extract and parse the plan JSON for validation
	plan := terraform.Show(t, terraformOptions)
	var planData map[string]interface{}
	err := json.Unmarshal([]byte(plan), &planData)
	if err != nil {
		t.Fatalf("Failed to parse Terraform plan: %v", err)
	}

	// Validate VNet name contains the environment variable
	vnetName := planData["planned_values"].(map[string]interface{})["root_module"].(map[string]interface{})["resources"].([]interface{})
	found := false
	for _, resource := range vnetName {
		res := resource.(map[string]interface{})
		if res["type"] == "azurerm_virtual_network" && strings.Contains(res["values"].(map[string]interface{})["name"].(string), environment) {
			found = true
			break
		}
	}
	assert.True(t, found, "VNet name should contain the environment variable")

	// Validate the VNet address space is 10.0.0.0/16
	vnetAddressSpace := vnetName[0].(map[string]interface{})["values"].(map[string]interface{})["address_space"].([]interface{})
	assert.Contains(t, vnetAddressSpace, "10.0.0.0/16", "VNet address space should be 10.0.0.0/16")

	// Validate that two subnets are being created
	subnetCount := 0
	for _, resource := range vnetName {
		res := resource.(map[string]interface{})
		if res["type"] == "azurerm_subnet" {
			subnetCount++
		}
	}
	assert.Equal(t, 2, subnetCount, "There should be exactly two subnets created")
}
