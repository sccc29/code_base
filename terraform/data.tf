data "aws_region" "current" {}
  
data "aws_caller_identity" "current" {}

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
      "arn:aws:s3:::prod-${data.aws_region.current.id}-starport-layer-bucket/*"
    ]
  }

}

data "aws_iam_policy_document" "ecs_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
  
}