# ## ECS Cluster
# resource "aws_ecs_cluster" "main" {
#   name = "demo-cluster"
# }

# # ECR Repository

# resource "aws_ecr_repository" "cat_gif_generator" {
#   name                 = "cat-gif-generator"
#   image_tag_mutability = "IMMUTABLE"
#   # image_scanning_configuration {
#   #   scan_on_push = true
#   # }

# }

# resource "aws_ecr_repository" "clumsy_bird" {
#   name                 = "clumsy-bird"
#   image_tag_mutability = "IMMUTABLE"
# }


# # IAM Roles & Policies

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name               = "ecsTaskExecutionRole"
#   assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

# }

# resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy" {
#   name       = "ecs-task-execution-policy"
#   roles      = [aws_iam_role.ecs_task_execution_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_policy" "ecr_pull_policy" {
#   name        = "ECRPullPolicy"
#   description = "Allows ECS task to pull images from ECR"

#   policy = data.aws_iam_policy_document.ecr_pull_policy.json

# }

# resource "aws_iam_role_policy_attachment" "ecr_pull" {
#   policy_arn = aws_iam_policy.ecr_pull_policy.arn
#   role       = aws_iam_role.ecs_task_execution_role.name
# }
