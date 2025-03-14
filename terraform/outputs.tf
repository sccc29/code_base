# output "cat_gif_generator" {
#   value = aws_ecr_repository.cat_gif_generator.repository_url

# }

# output "clumsy_bird" {
#   value = aws_ecr_repository.clumsy_bird.repository_url

# }

output "ecr_repository_urls" {
  value = [for repo in module.ecs.ecr_repository_url : repo]
  
}

output "alb_dns" {
  value = aws_lb.main.dns_name

}