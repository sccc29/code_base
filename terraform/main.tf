resource "aws_ecs_task_definition" "cat_gif" {
  family                   = "cat-gif-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = "512"
  cpu                      = "256"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "cat-gif-generator",
      image     = "${aws_ecr_repository.cat_gif_generator.repository_url}:latest",
      cpu       = 256,
      memory    = 512,
      essential = true,
      environment = [
        { "name" : "API_KEY", "value" : "${var.api_key}" }
      ],
      portMappings = [
        {
          containerPort = 8000,
          hostPort      = 8000
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "/ecs/cat-gif-generator",
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "cat_gif" {
  name                 = "cat-gif-service"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.cat_gif.arn
  launch_type          = "FARGATE"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets         = [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cat_gif.arn
    container_name   = "cat-gif-generator"
    container_port   = 8000
  }
}

resource "aws_cloudwatch_log_group" "ecs_cat_logs" {
  name = "/ecs/cat-gif-generator"
}


resource "aws_ecs_task_definition" "clumsy_bird" {
  family                   = "clumsy-bird"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = "512"
  cpu                      = "256"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "clumsy-bird",
      image     = "${aws_ecr_repository.clumsy_bird.repository_url}:latest",
      cpu       = 256,
      memory    = 512,
      essential = true,
      portMappings = [
        {
          containerPort = 8001,
          hostPort      = 8001
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = "/ecs/clumsy-bird",
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "clumsy_bird_service" {
  name            = "clumsy-bird-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.clumsy_bird.arn
  launch_type     = "FARGATE"
  desired_count = 1
  force_new_deployment = true



  network_configuration {
    subnets         = [for subnet in aws_subnet.private : subnet.id]
    security_groups = [aws_security_group.ecs_sg.id]
    # assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.clumsy_bird.arn
    container_name   = "clumsy-bird"
    container_port   = 8001
  }
}


resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/clumsy-bird"
}
