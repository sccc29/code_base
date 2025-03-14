provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::944613854055:role/tf-worker"
  }
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.89.0"
    }
  }
  required_version = ">= 1.11"
}