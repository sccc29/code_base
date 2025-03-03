
variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"

}

#-------------------------
# VPC & Subnets
#-------------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private Subnet A"
  }

}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private Subnet B"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Demo IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }

}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id

}

resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = {
    Name = "Demo NGW EIP"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "Demo NGW"
  }

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id

  }

  tags = {
    Name = "Private Route Table"
  }
}
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id

}

## ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "demo-cluster"
}

resource "aws_ecr_repository" "cat_gif_generator" {
  name = "cat-gif-generator"
  
}



# IAM Roles & Policies

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
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
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = aws_ecr_repository.cat_gif_generator.arn
      },
      {
      Effect   = "Allow"
      Action   = [
        "s3:GetObject",
    ]
    Resource = "arn:aws:s3:::prod-${var.aws_region}-starport-layer-bucket/*"
  }
]
})
}

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}


# Security Group
#-------------------------
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecs-sg-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-------------------------
# Load Balancer
#-------------------------
resource "aws_lb" "main" {
  name               = "main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

resource "aws_lb_target_group" "cat_gif" {
  name     = "cat-gif"
  port     = 8000
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/generate-cat-gif"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}



resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cat_gif.arn
  }
}


resource "aws_ecs_task_definition" "cat_gif" {
  family                   = "cat-gif-task"
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
      name      = "cat-gif-generator",
      image     = "${aws_ecr_repository.cat_gif_generator.repository_url}:latest",
      cpu       = 256,
      memory    = 512,
      essential = true,
      environment = [
        { "name": "API_KEY", "value": "${var.api_key}" }
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
  name            = "cat-gif-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.cat_gif.arn
  launch_type     = "FARGATE"
  desired_count = 1
  force_new_deployment = true

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
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