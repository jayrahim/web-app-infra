package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestEFSModule(t *testing.T) {
	t.Parallel()

	projectName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../examples/default",

		Vars: map[string]interface{}{
			"project_name": projectName,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	efsSGId := terraform.Output(t, terraformOptions, "efs_sg_id")
	assert.Contains(t, efsSGId, "sg-", "Expected to return true")

	efsARN := terraform.Output(t, terraformOptions, "efs_arn")
	efsMountTargetsFileSystemARN := terraform.OutputList(t, terraformOptions, "efs_arns_asssociated_with_mount_targets")

	for _, arn := range efsMountTargetsFileSystemARN {
		assert.Equal(t, arn, efsARN, "Exepected to return true")
	}

	mountTargetDNSNames := terraform.OutputList(t, terraformOptions, "efs_mount_target_dns_names")
	assert.True(t, len(mountTargetDNSNames) == 2 && mountTargetDNSNames[0] != mountTargetDNSNames[1])
}
