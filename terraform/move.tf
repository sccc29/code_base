# moved {
#   from = aws_ecs_cluster.main
#   to = module.ecs.aws_ecs_cluster.main
# }

# moved {
#     from = aws_iam_role.ecs_task_execution_role
#     to = module.ecs.aws_iam_role.ecs_task_execution_role
# }

# moved {
#     from = aws_iam_policy_attachment.ecs_task_execution_role_policy
#     to = module.ecs.aws_iam_policy_attachment.ecs_task_execution_role_policy
# }

# moved {
#     from = aws_iam_policy.ecr_pull_policy
#     to = module.ecs.aws_iam_policy.ecr_pull_policy
# }

# moved {
#     from = aws_iam_role_policy_attachment.ecr_pull
#     to = module.ecs.aws_iam_role_policy_attachment.ecr_pull
# }

# moved {
#     from = aws_ecr_repository.cat_gif_generator
#     to = module.ecs.aws_ecr_repository.main["cat-gif-generator"]

# }

# moved {
#     from = aws_ecr_repository.clumsy_bird
#     to = module.ecs.aws_ecr_repository.main["clumsy-bird"]
# }


#### Network Move

moved {
    from = aws_vpc.main
    to = module.network.aws_vpc.main
}

moved {
    from = aws_subnet.public
    to = module.network.aws_subnet.public
}

moved {
    from = aws_subnet.private
    to = module.network.aws_subnet.private
}

moved {
    from = aws_internet_gateway.main
    to = module.network.aws_internet_gateway.main
}

moved {
    from = aws_route_table.public
    to = module.network.aws_route_table.public
}

moved {
    from = aws_route_table.private
    to = module.network.aws_route_table.private
}

moved {
    from = aws_route_table_association.public
    to = module.network.aws_route_table_association.public
}

moved {
    from = aws_route_table_association.private
    to = module.network.aws_route_table_association.private
}

moved {
    from = aws_eip.ngw
    to = module.network.aws_eip.ngw
}

moved {
    from = aws_nat_gateway.main
    to = module.network.aws_nat_gateway.main
}

moved {
  from = aws_cloudwatch_log_group.vpc_flow_logs
    to = module.network.aws_cloudwatch_log_group.vpc_flow_logs
}

moved {
  from = aws_iam_role.vpc_flow_logs_role
    to = module.network.aws_iam_role.vpc_flow_logs_role
  
}

moved {
  from = aws_iam_role_policy.vpc_flow_logs_policy
    to = module.network.aws_iam_role_policy.vpc_flow_logs_policy
}

moved {
    from = aws_flow_log.vpc_flow_logs
    to = module.network.aws_flow_log.vpc_flow_logs
       
}

moved {
    from = aws_s3_bucket.cloudtrail_logs
    to = module.network.aws_s3_bucket.cloudtrail_logs
}

moved {
    from = aws_cloudtrail.network_trail
    to = module.network.aws_cloudtrail.network_trail
}

moved {
    from = aws_iam_role.cloud_trail
    to = module.network.aws_iam_role.cloud_trail
  
}

moved {
    from = aws_cloudwatch_log_group.cloud_trail
    to = module.network.aws_cloudwatch_log_group.cloud_trail

}

moved {
    from = aws_iam_role_policy.cloud_trail_policy
    to = module.network.aws_iam_role_policy.cloud_trail_policy
}

moved {
    from = aws_s3_bucket_policy.cloudtrail_policy
    to = module.network.aws_s3_bucket_policy.cloudtrail_policy
}

moved {
    from = aws_cloudwatch_log_metric_filter.error_filter
    to = module.network.aws_cloudwatch_log_metric_filter.error_filter
}

moved {
    from = aws_cloudwatch_metric_alarm.error_alarm
    to = module.network.aws_cloudwatch_metric_alarm.error_alarm
}

moved {
    from = aws_sns_topic.error_notifications
    to = module.network.aws_sns_topic.error_notifications
}

moved {
    from = aws_sns_topic_subscription.email_subscription
    to = module.network.aws_sns_topic_subscription.email_subscription
}