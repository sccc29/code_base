## ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "demo-cluster"
}

# ECR Repository

resource "aws_ecr_repository" "cat_gif_generator" {
  name = "cat-gif-generator"

}

resource "aws_ecr_repository" "clumsy_bird" {
  name = "clumsy-bird"

}


# IAM Roles & Policies

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "ecs-tasks.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_task_execution_role_policy" {
  name       = "ecs-task-execution-policy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "ECRPullPolicy"
  description = "Allows ECS task to pull images from ECR"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = ["ecr:GetAuthorizationToken"]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage"
#         ]
#         Resource = [
#           aws_ecr_repository.cat_gif_generator.arn,
#           aws_ecr_repository.clumsy_bird.arn
#         ]
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#         ]
#         Resource = "arn:aws:s3:::prod-${data.aws_region.current}-starport-layer-bucket/*"
#       }
#     ]
#   })
}

data "aws_iam_policy_document" "ecr_pull_policy" {
    statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
    }
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
          ]
    resources = [
        aws_ecr_repository.cat_gif_generator.arn,
        aws_ecr_repository.clumsy_bird.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::prod-${data.aws_region.current}-starport-layer-bucket/*"
    ]
  }

}


  

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}