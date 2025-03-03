provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::944613854055:role/tf-worker"
  }
  region = "us-east-1"
}