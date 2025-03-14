variable "cluster_name" {
    description = "The name of the ECS cluster"
    type        = string
  
}

variable "service" {
    description = "A map of services to create"
    type        = map(object({
      name = string
    }))
    default = {
      "Name" = {
        name = "Name"
      }
    }
  
}