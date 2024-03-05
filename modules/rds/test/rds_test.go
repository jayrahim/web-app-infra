package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestRDSModule(t *testing.T) {
	t.Parallel()

	dbName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))
	portNumber := int64(3306)
	awsRegion := "us-east-1"

	// Testing that a schema exists isn't currently possible because the db is private. Consider setting up a VPN tunnel or making db public for testing. 
	// rdsUsernameParameterStoreKey := fmt.Sprintf("/%-s/db/master_username", dbName)
	// rdsPasswordParameterStoreKey := fmt.Sprintf("/%-s/db/master_password", dbName)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../examples/default",

		Vars: map[string]interface{}{
			"db_name":              dbName,
			"engine":               "mysql",
			"major_engine_version": "8.0",
			"project_name":         dbName,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	address := aws.GetAddressOfRdsInstance(t, dbName, awsRegion)
	assert.NotNil(t, address)

	port := aws.GetPortOfRdsInstance(t, dbName, awsRegion)
	assert.Equal(t, portNumber, port)

	sgId := terraform.Output(t, terraformOptions, "rds_sg_id")
	assert.Contains(t, sgId, "sg-", "Expected to return true")

	subnetGroupName := terraform.Output(t, terraformOptions, "rds_subnet_group_name")
	assert.Contains(t, subnetGroupName, "terratest-", "Expected to return true")

	rdsEndpoint := terraform.Output(t, terraformOptions, "rds_endpoint")
	assert.Contains(t, rdsEndpoint, "terratest-", "Expected to return true")

	// rdsUsername := aws.GetParameter(t, awsRegion, rdsUsernameParameterStoreKey)
	// rdsPassword := aws.GetParameter(t, awsRegion, rdsPasswordParameterStoreKey)
	// mysqlSchemaExists := aws.GetWhetherSchemaExistsInRdsMySqlInstance(t, rdsEndpoint, portNumber, rdsUsername, rdsPassword, "mysql")
	// assert.True(t, mysqlSchemaExists, true, "Expected to return true")
}
