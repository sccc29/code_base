terraform {
  backend "s3" {
    bucket       = "412-state-pgh"
    key          = "demo/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    assume_role = {
      role_arn = "arn:aws:iam::944613854055:role/tf-worker"
    }
    encrypt = true
  }
}