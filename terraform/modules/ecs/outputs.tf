output "ecr_repository_url" {
  value = {for repo, value in aws_ecr_repository.main : value.name => value.repository_url}
  
}

output "ecs_iam_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
  
}