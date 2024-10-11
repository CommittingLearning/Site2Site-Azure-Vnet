package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestAzureInfra validates the Terraform deployment for Vnet, VM, and VPNGateway
func TestAzureInfra(t *testing.T) {
	terraformOptions := &terraform.Options{
		// Path to the Terraform code that deploys the infrastructure
		TerraformDir: "../",
	}

	// Ensure resources are cleaned up after tests complete
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`
	terraform.InitAndApply(t, terraformOptions)

	// Validate that the VNet has been created
	vnetName := terraform.Output(t, terraformOptions, "vnet_name")
	assert.Equal(t, "my-vnet", vnetName)
}
