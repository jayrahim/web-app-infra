package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"regexp"
	"testing"
)

var testDir string = "../examples/default"

func IsValidVPCID(vpcID string) bool {
	vpcIDPattern := regexp.MustCompile(`^vpc-[0-9a-fA-F]{17}$`)
	return vpcIDPattern.MatchString(vpcID)
}

func TestVPC(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testDir,
	})

	terraform.InitAndApply(t, terraformOptions)

	vpc_ID := terraform.Output(t, terraformOptions, "vpc_id")
	assert.True(t, IsValidVPCID(vpc_ID), "Expected to return true")
}

func TestSubnets(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testDir,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	outputNames := []string{"public_subnet_ids", "web_subnet_ids", "app_subnet_ids", "db_subnet_ids"}

	for _, name := range outputNames {
		assert.Equal(t, 2, len(terraform.OutputList(t, terraformOptions, name)))
	}
}

func TestIGW(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testDir,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	igwID := terraform.Output(t, terraformOptions, "igw_id")

	assert.True(t, len(igwID) != 0, "Expected to return true")
}

func TestNATGWs(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: testDir,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	assert.Equal(t, 2, len(terraform.OutputList(t, terraformOptions, "nat_gw_ids")))
}