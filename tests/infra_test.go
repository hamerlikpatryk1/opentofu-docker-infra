package test

import (
    "testing"
    "strings"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestRootInfrastructure(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "../",
        VarFiles:     []string{"infra/envs/dev.tfvars"},
		TerraformBinary: "/usr/bin/tofu",
    }

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	subnetID := terraform.Output(t, terraformOptions, "public_subnet_id")
    ec2IP := terraform.Output(t, terraformOptions, "ec2_public_ip")
	sgID := terraform.Output(t, terraformOptions, "security_group_id")

    assert.NotEmpty(t, vpcID, "VPC ID mustn't be empty")
    assert.NotEmpty(t, subnetID, "Subnet ID mustn't be empty")
    assert.True(t, strings.Contains(ec2IP, "."), "EC2 public IP should be valid")
	assert.NotEmpty(t, sgID, "Security Group ID mustn't be empty")
	assert.NotEmpty(t, ec2IP, "EC2 public IP mustn't be empty")
}