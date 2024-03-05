package test

import (
	"fmt"
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestNetworkingModule(t *testing.T) {
	t.Parallel()

	projectName := fmt.Sprintf("terratest-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../examples/default",

		Vars: map[string]interface{} {
			"project_name": projectName,
			"vpc_cidr":     "172.16.0.0/16",
			"public_cidrs": []string{"172.16.0.0/20", "172.16.16.0/20"},
			"web_cidrs":    []string{"172.16.32.0/20", "172.16.48.0/20"},
			"app_cidrs":    []string{"172.16.64.0/20", "172.16.80.0/20"},
			"db_cidrs":     []string{"172.16.96.0/20", "172.16.112.0/20"},
			"cache_cidrs":  []string{"172.16.128.0/20", "172.16.144.0/20"},
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	vpc_Id := terraform.Output(t, terraformOptions, "vpc_id")
	vpcIdPattern := regexp.MustCompile(`^vpc-[0-9a-fA-F]{17}$`)
	assert.True(t, vpcIdPattern.MatchString(vpc_Id), "Expected to return true")

	subnetIds := []string{"public_subnet_ids", "web_subnet_ids", "app_subnet_ids", "db_subnet_ids", "cache_subnet_ids"}
	for _, name := range subnetIds {
		assert.Equal(t, 2, len(terraform.OutputList(t, terraformOptions, name)))
	}

	igwId := terraform.Output(t, terraformOptions, "igw_id")
	assert.True(t, len(igwId) != 0, "Expected to return true")

	rtbIds := terraform.OutputList(t, terraformOptions, "route_table_ids")
	assert.Equal(t, 2, len(rtbIds))

	defaultRouteStates := terraform.OutputList(t, terraformOptions, "default_route_states")

	for _, state := range defaultRouteStates {
		assert.Equal(t, "active", state, "Expected to return true")
	}

	publicRouteTablePublicSubnetsAssociationIds := terraform.OutputList(t, terraformOptions, "public_rtb_public_subnets_association_id")
	assert.Equal(t, 2, len(publicRouteTablePublicSubnetsAssociationIds), "Expected to return true")

	publicRouteTableWebSubnetsAssociationIds := terraform.OutputList(t, terraformOptions, "public_rtb_web_subnets_association_id")
	assert.Equal(t, 2, len(publicRouteTableWebSubnetsAssociationIds), "Expected to return true")

	privateRouteTableAppSubnetsAssociationIds := terraform.OutputList(t, terraformOptions, "private_rtb_app_subnets_association_id")
	assert.Equal(t, 2, len(privateRouteTableAppSubnetsAssociationIds), "Expected to return true")

	privateRouteTableDBSubnetsAssociationIds := terraform.OutputList(t, terraformOptions, "private_rtb_db_subnets_association_id")
	assert.Equal(t, 2, len(privateRouteTableDBSubnetsAssociationIds), "Expected to return true")

	privateRouteTableCacheSubnetsAssociationIds := terraform.OutputList(t, terraformOptions, "private_rtb_cache_association_id")
	assert.Equal(t, 2, len(privateRouteTableCacheSubnetsAssociationIds), "Expected to return true")

	natGatewayIds := terraform.OutputList(t, terraformOptions, "nat_gw_ids"); 
	assert.Equal(t, 2, len(natGatewayIds), "Expected to return true")
}