package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
	"time"
)

func TestApplicationModule(t *testing.T) {
	t.Parallel()

	appLBName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))
	webTerratestName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))
	appTerratestName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../examples/default",

		Vars: map[string]interface{}{
			"app_lb_name":       appLBName,
			"web_server_prefix": webTerratestName,
			"app_server_prefix": appTerratestName,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	appServerRole := terraform.Output(t, terraformOptions, "app_server_role")
	assert.Equal(t, appServerRole, appTerratestName+"-role")

	appServerProfile := terraform.Output(t, terraformOptions, "app_server_profile")
	assert.Equal(t, appServerProfile, appTerratestName+"-instance-profile")

	appLBDNSName := terraform.Output(t, terraformOptions, "app_lb_dns_name")
	assert.Contains(t, appLBDNSName, "internal")

	appTargetGroupName := terraform.Output(t, terraformOptions, "app_target_group_name")
	assert.Equal(t, appTargetGroupName, appTerratestName+"-tg")

	appASGMinCapacity := terraform.Output(t, terraformOptions, "app_server_asg_min")
	appASGMaxCapacity := terraform.Output(t, terraformOptions, "app_server_asg_max")
	appASGDesiredCapacity := terraform.Output(t, terraformOptions, "app_server_asg_desired")
	assert.True(t, appASGMinCapacity == "1" && appASGMaxCapacity == "3" && appASGDesiredCapacity == "1", "Expected to return true")

	webLBDNSName := terraform.Output(t, terraformOptions, "web_lb_dns_name")
	assert.Contains(t, webLBDNSName, "elb.amazonaws.com")

	webTargetGroupName := terraform.Output(t, terraformOptions, "web_target_group_name")
	assert.Equal(t, webTargetGroupName, webTerratestName+"-tg")

	webServerRole := terraform.Output(t, terraformOptions, "web_server_role")
	assert.Equal(t, webServerRole, webTerratestName+"-role")

	webServerProfile := terraform.Output(t, terraformOptions, "web_server_profile")
	assert.Equal(t, webServerProfile, webTerratestName+"-instance-profile")

	webASGMinCapacity := terraform.Output(t, terraformOptions, "web_server_asg_min")
	webASGMaxCapacity := terraform.Output(t, terraformOptions, "web_server_asg_max")
	webASGDesiredCapacity := terraform.Output(t, terraformOptions, "web_server_asg_desired")
	assert.True(t, webASGMinCapacity == "1" && webASGMaxCapacity == "3" && webASGDesiredCapacity == "1", "Expected to return true")

	http_helper.HttpGetWithRetry(t, "http://"+webLBDNSName+"/health", nil, 200, "Healthy!", 40, 10*time.Second)

	http_helper.HttpGetWithRetryWithCustomValidation(t, "http://"+webLBDNSName, nil, 40, 10*time.Second,
		func(statusCode int, body string) bool {
			return statusCode == 200
		},
	)
}