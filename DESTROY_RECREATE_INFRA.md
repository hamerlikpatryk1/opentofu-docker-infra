# Operations & Maintenance Guide

## Destroying and Recreating Infrastructure

### Prerequisites

Before performing any destroy or recreation operations:

```bash
# Ensure you're in the correct directory
cd /home/phamerli/git_repos/opentofu-docker-infra

# Verify AWS credentials are configured
aws sts get-caller-identity

# Check current state
tofu state list

# (Optional) Create a backup of current state
cp terraform.tfstate terraform.tfstate.backup.$(date +%s)
```

### Full Infrastructure Destruction

#### Option 1: Destroy Everything in One Command

```bash
# WARNING: This will delete all AWS resources
# Destroy using the current environment (default: dev)
tofu destroy

# Or specify a specific environment
tofu destroy -var-file="infra/envs/dev.tfvars"
tofu destroy -var-file="infra/envs/staging.tfvars"
tofu destroy -var-file="infra/envs/prod.tfvars"

# To skip the interactive confirmation
tofu destroy -auto-approve

# With verbose output for debugging
tofu destroy -auto-approve -verbose
```

#### Option 2: Destroy Specific Resources

```bash
# Destroy only EC2 instance (keeps VPC and Security Group)
tofu destroy -target=module.ec2

# Destroy only Security Group
tofu destroy -target=module.security_group

# Destroy only VPC and Subnets
tofu destroy -target=module.vpc

# Destroy in order (if dependencies matter)
tofu destroy -target=module.ec2 -auto-approve
tofu destroy -target=module.security_group -auto-approve
tofu destroy -target=module.vpc -auto-approve
```

### Full Infrastructure Recreation

#### Quick Rebuild (Destroy + Create)

```bash
# One-command approach (not recommended for production)
tofu destroy -auto-approve && tofu apply -auto-approve -var-file="infra/envs/dev.tfvars"
```

#### Recommended Approach: Staged Recreation

```bash
# Step 1: Plan the destruction
tofu destroy -var-file="infra/envs/dev.tfvars"
# Review and confirm

# Step 2: Verify everything is destroyed
tofu state list  # Should be empty

# Step 3: Plan infrastructure creation
tofu plan -var-file="infra/envs/dev.tfvars" -out=tfplan

# Step 4: Review the plan carefully
# Review outputs and ensure correct resources will be created

# Step 5: Apply the plan
tofu apply tfplan

# Step 6: Verify outputs
tofu output
# Expected output:
# ec2_public_ip = "<your-new-public-ip>"
# public_subnet_id = "subnet-xxxxxxxxx"
# security_group_id = "sg-xxxxxxxxx"
# vpc_id = "vpc-xxxxxxxxx"
```

### Post-Deployment Docker Setup

After infrastructure is recreated, deploy Docker services:

```bash
# SSH into the EC2 instance
EC2_IP=$(tofu output -raw ec2_public_ip)
ssh -i your-key.pem ec2-user@$EC2_IP

# On the EC2 instance
cd /opt/app  # or wherever Docker Compose is located

# Build and start services
docker-compose up -d

# Verify services are running
docker-compose ps

# View logs
docker-compose logs -f

# Access your services:
# Web App: http://<EC2_IP>:8080
# Prometheus: http://<EC2_IP>:9090
# Grafana: http://<EC2_IP>:3000
```

### State Management

```bash
# List all resources in state
tofu state list

# Show details of a specific resource
tofu state show module.ec2.aws_instance.this

# Remote state backup
tofu state pull > terraform.tfstate.local.backup

# Clear specific resource from state (dangerous!)
tofu state rm module.ec2.aws_instance.this
```

### Disaster Recovery

#### Scenario: Need to recreate a single resource

```bash
# Remove resource from state without destroying it
tofu state rm module.ec2.aws_instance.this

# Plan and apply - will create new resource
tofu plan -var-file="infra/envs/dev.tfvars"
tofu apply -auto-approve -var-file="infra/envs/dev.tfvars"
```

#### Scenario: Rollback to previous state

```bash
# If using remote state, you may have versioning available
# For local state, restore from backup
cp terraform.tfstate.backup terraform.tfstate

# Sync with AWS
tofu refresh

# Verify state matches reality
tofu plan  # Should show no changes
```

---
