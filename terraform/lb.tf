#-------------------------
# Load Balancer
#-------------------------
resource "aws_lb" "main" {
  name               = "main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_target_group" "cat_gif" {
  name        = "cat-gif"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    path                = "/generate-cat-gif"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "clumsy_bird" {
  name     = "clumsy-bird-tg"
  port     = 8001
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.main.id
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

resource "aws_lb_listener_rule" "cat_gif_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  condition{
    path_pattern {
        values = ["/clumsy-bird"]
    }
    
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clumsy_bird.arn
  }
}
