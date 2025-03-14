#-------------------------
# VPC & Subnets
#-------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = {
    Name = "${var.vpc_name} Private Subnet ${each.key}"
  }

}

resource "aws_subnet" "public" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name} Public Subnet ${each.key}"
  }

}



resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name} Public Route Table"
  }

}

resource "aws_route_table_association" "public" {
  for_each       = { for x, y in aws_subnet.public : x => y.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name} NGW EIP"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public["us-east-1a"].id

  tags = {
    Name = var.vpc_name
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id

  }

  tags = {
    Name = "${var.vpc_name} Private Route Table"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = { for x, y in aws_subnet.private : x => y.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id

}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "/aws/vpc/${aws_vpc.main.id}-flow-logs"
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "VPCFlowLogsRole"

  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_sts.json
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "VPCFlowLogsPolicy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = data.aws_iam_policy_document.vpc_flow_logs.json
}



resource "aws_flow_log" "vpc_flow_logs" {
  vpc_id          = aws_vpc.main.id
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
}


resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "my-cloudtrail-logs-bucket-423"
}


resource "aws_cloudtrail" "network_trail" {
  name                          = "networking-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  event_selector {
    read_write_type           = "All"
    include_management_events = true

  }
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloud_trail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloud_trail.arn
}

resource "aws_iam_role" "cloud_trail" {
  name = "CloudTrailRole"

  assume_role_policy = data.aws_iam_policy_document.vpc_cloudtrail_logs_sts.json


}

resource "aws_iam_role_policy" "cloud_trail_policy" {
  name = "CloudTrailPolicy"
  role = aws_iam_role.cloud_trail.id

  policy = data.aws_iam_policy_document.vpc_cloudtrail_logs.json


}

resource "aws_cloudwatch_log_group" "cloud_trail" {
  name              = "CloudTrail/DefaultLogGroup"
  retention_in_days = 90

}

# S3 Bucket Policy to Allow CloudTrail Logging
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = data.aws_iam_policy_document.vpc_cloudtrail_bucket_logs.json

}

# ------------------------------
# CloudWatch Log Metric Filter
# ------------------------------
resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "ErrorMetricFilter"
  log_group_name = aws_cloudwatch_log_group.vpc_flow_logs.name

  # Define the log pattern to match (modify as needed)
  pattern = "%REJECT%"

  metric_transformation {
    name      = "RejectedTrafficCount"
    namespace = "VPCFlowLogs"
    value     = "1"
  }
}

# ------------------------------
# CloudWatch Alarm (Trigger at 10 occurrences)
# ------------------------------
resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "VPCFlowLogsErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].namespace
  period              = 60 # 1-minute interval
  statistic           = "Sum"
  threshold           = 10 # Trigger when log appears 10+ times
  alarm_description   = "Triggers when 'REJECT' appears 10 times in VPC Flow Logs"
  alarm_actions       = [aws_sns_topic.error_notifications.arn]
}

# ------------------------------
# SNS Topic for Email Notification
# ------------------------------
resource "aws_sns_topic" "error_notifications" {
  name = "ErrorNotifications"
}

# Subscribe an email to the SNS topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.error_notifications.arn
  protocol  = "email"
  endpoint  = "samuel@cadavid.com" # Change this to your email
}
