moved {
  from = aws_ecs_cluster.main
  to = module.ecs.aws_ecs_cluster.main
}

moved {
    from = aws_iam_role.ecs_task_execution_role
    to = module.ecs.aws_iam_role.ecs_task_execution_role
}

moved {
    from = aws_iam_policy_attachment.ecs_task_execution_role_policy
    to = module.ecs.aws_iam_policy_attachment.ecs_task_execution_role_policy
}

moved {
    from = aws_iam_policy.ecr_pull_policy
    to = module.ecs.aws_iam_policy.ecr_pull_policy
}

moved {
    from = aws_iam_role_policy_attachment.ecr_pull
    to = module.ecs.aws_iam_role_policy_attachment.ecr_pull
}

