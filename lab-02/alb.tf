resource "aws_lb" "lab02-alb" {
  name               = "lab02-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ingress-http.id]
  subnets            = [aws_subnet.lab02-subnet-public-1a.id, aws_subnet.lab02-subnet-private-1b.id]
}

resource "aws_lb_target_group" "lab-02-alb-target-group" {
  name     = "lab02-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.lab02-vpc.id
}

resource "aws_lb_target_group_attachment" "lab-02-alb-target-group-attachment" {
  target_group_arn = aws_lb_target_group.lab-02-alb-target-group.arn
  target_id        = aws_instance.private-app-server.id
  port             = 80
}

resource "aws_lb_listener" "lab02-lb-aws_lb_listener" {
  load_balancer_arn = aws_lb.lab02-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lab-02-alb-target-group.arn
  }
}