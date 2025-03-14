data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# data "aws_iam_policy_document" "ecr_pull_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:GetAuthorizationToken"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage"
#     ]
#     resources = [
#       aws_ecr_repository.cat_gif_generator.arn,
#       aws_ecr_repository.clumsy_bird.arn
#     ]
#   }
#   statement {
#     effect = "Allow"
#     actions = [
#       "s3:GetObject"
#     ]
#     resources = [
#       "arn:aws:s3:::prod-${data.aws_region.current.id}-starport-layer-bucket/*"
#     ]
#   }

# }

# data "aws_iam_policy_document" "ecs_assume_role" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }

# }

data "aws_iam_policy_document" "vpc_flow_logs_sts" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }

}

data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = [
      aws_cloudwatch_log_group.vpc_flow_logs.arn,
      "${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"
    ]
  }

}

data "aws_iam_policy_document" "vpc_cloudtrail_logs_sts" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

}

data "aws_iam_policy_document" "vpc_cloudtrail_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = [
      aws_cloudwatch_log_group.cloud_trail.arn,
      "${aws_cloudwatch_log_group.cloud_trail.arn}:*"
    ]
  }

}

data "aws_iam_policy_document" "vpc_cloudtrail_bucket_logs" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_logs.arn]
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/networking-trail"]
      variable = "aws:SourceArn"
    }
  }
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"

    }
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:trail/networking-trail"]
      variable = "aws:SourceArn"
    }
  }

}


