variable "private_subnets" {
  description = "A map of private subnets"
  type        = map(string)

}

variable "public_subnets" {
  description = "A map of public subnets"
  type        = map(string)


}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string

}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  
}