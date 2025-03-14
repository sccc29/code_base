module "ecs" {
  source = "./modules/ecs"
  cluster_name = "demo-cluster"
  service = {
    cat-gif-generator = {
      name = "cat-gif-generator"
    },
    clumsy-bird = {
      name = "clumsy-bird"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name = "Demo"
  private_subnets = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
  "us-east-1c" = "10.0.3.0/24"
}
public_subnets = {
  "us-east-1a" = "10.0.4.0/24"
  "us-east-1b" = "10.0.5.0/24"
  "us-east-1c" = "10.0.6.0/24"
}
  
}