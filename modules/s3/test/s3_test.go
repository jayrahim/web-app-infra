package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Module(t *testing.T) {
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

	bucketName := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Contains(t, bucketName, projectName)

	bucketDomainName := terraform.Output(t, terraformOptions, "bucket_domain_name")
	assert.Contains(t, bucketDomainName, "s3.amazonaws.com")
}