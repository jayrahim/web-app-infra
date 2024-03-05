package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestRedisModule(t *testing.T) {
	t.Parallel()

	projectName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))
	replicationGroupName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../examples/default",

		Vars: map[string]interface{}{
			"project_name":         projectName,
			"replication_group_id": replicationGroupName,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	clusterId := terraform.Output(t, terraformOptions, "redis_replication_group_id")
	assert.Equal(t, clusterId, replicationGroupName)

	readerEndpoint := terraform.Output(t, terraformOptions, "redis_replication_group_reader_endpoint")
	assert.Contains(t, readerEndpoint, "cache.amazonaws.com", "Execpted to return true")

	primaryEndpoint := terraform.Output(t, terraformOptions, "redis_replication_group_primary_endpoint")
	assert.Contains(t, primaryEndpoint, "cache.amazonaws.com", "Execpted to return true")
	assert.NotEqual(t, readerEndpoint, primaryEndpoint, "Expected to return true")

	clusterSecurityGroupId := terraform.Output(t, terraformOptions, "security_group_id")
	assert.Contains(t, clusterSecurityGroupId, "sg-")

	subnetIds := terraform.OutputList(t, terraformOptions, "redis_subnet_group_ids")
	for _, id := range subnetIds {
		assert.Contains(t, id, "subnet-")
	}

	logGroupArn := terraform.Output(t, terraformOptions, "redis_log_group_arn")
	assert.Contains(t, logGroupArn, "arn:aws:logs:")
}
