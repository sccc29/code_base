# Terraform Infrastructure for AWS ECS Deployment

## Overview
This Terraform project provisions an AWS infrastructure, including networking, security groups, load balancing, and an ECS cluster for deploying containerized applications. The deployment is configured using multiple Terraform modules and resources.

## Prerequisites
Before using this Terraform configuration, ensure that you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured with necessary permissions
- A valid AWS account
- [GitHub Actions](https://github.com/features/actions) (if deploying via CI/CD)

## File Structure

```
├── main.tf            # Main Terraform configuration
├── provider.tf        # AWS provider configuration
├── variables.tf       # Input variables
├── terraform.tfvars   # Variable values
├── network.tf         # VPC, subnets, and networking resources
├── sg.tf              # Security groups
├── lb.tf              # Load Balancer configuration
├── ecs_cluster.tf     # ECS Cluster setup
├── outputs.tf         # Output variables
```

## Usage

### 1. Initialize Terraform
Run the following command to initialize Terraform and download required providers and modules:
```sh
terraform init
```

### 2. Plan Infrastructure
To preview the changes Terraform will make, run:
```sh
terraform plan
```

### 3. Apply Configuration
To create the resources defined in the configuration, execute:
```sh
terraform apply -auto-approve
```

### 4. Destroy Infrastructure
To delete all provisioned resources, run:
```sh
terraform destroy -auto-approve
```

## Resources Created
This Terraform configuration provisions the following AWS resources:

- **VPC & Subnets**: A dedicated VPC with public and private subnets.
- **Security Groups**: Security groups for controlling inbound and outbound traffic.
- **Load Balancer**: An AWS Application Load Balancer (ALB) for routing traffic.
- **ECS Cluster**: An Amazon ECS cluster for running containerized workloads.

## Outputs
The following outputs are available after deployment:
- Load balancer DNS name
- ECS cluster name
- VPC ID

## CI/CD Integration
This configuration can be deployed using GitHub Actions, integrating Terraform into your CI/CD pipeline.



