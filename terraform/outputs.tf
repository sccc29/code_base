output "cat_gif_generator" {
  value = aws_ecr_repository.cat_gif_generator.repository_url
  
}

output "alb_dns" {
  value = aws_lb.main.dns_name
  
}