variable "api_key" {
  description = "The API key for the application"
  type        = string

}

variable "private_subnets" {
  description = "A map of private subnets"
  type        = map(string)

}

variable "public_subnets" {
  description = "A map of public subnets"
  type        = map(string)

}


variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"

}