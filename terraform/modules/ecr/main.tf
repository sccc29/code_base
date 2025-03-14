resource "aws_ecr_repository" "main" {
  for_each = var.service
  name                 = each.key
  image_tag_mutability = "IMMUTABLE"
  # image_scanning_configuration {
  #   scan_on_push = true
  # }

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

output "ecr_repository_url" {
  value = {for repo, value in aws_ecr_repository.main : value.name => value.repository_url}
  
}