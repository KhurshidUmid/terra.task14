locals {
  user_data_script = base64encode(<<-EOF
              #!/bin/bash
              COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
              COMPUTE_INSTANCE_ID=$(ec2-metadata --instance-id | cut -d' ' -f2)
              cat > /var/www/html/index.html <<HTML
              <html>
              <head><title>Instance Info</title></head>
              <body>
              <h1>This message was generated on instance $COMPUTE_INSTANCE_ID with the following UUID $COMPUTE_MACHINE_UUID</h1>
              </body>
              </html>
              HTML
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  )
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_prefix}-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  network_interfaces {
    delete_on_termination       = true
    security_groups             = [var.ssh_security_group_id, var.private_http_sg_id]
    associate_public_ip_address = true
  }

  user_data = local.user_data_script

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_prefix}-instance"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                = "${var.project_prefix}-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.desired_capacity
  min_size            = var.desired_capacity
  max_size            = var.desired_capacity
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "${var.project_prefix}-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_lb" "main" {
  name_prefix        = "lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_http_sg_id]
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.project_prefix}-lb"
  }
}

resource "aws_lb_target_group" "main" {
  name_prefix = "tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_autoscaling_attachment" "main" {
  autoscaling_group_name = aws_autoscaling_group.main.id
  lb_target_group_arn    = aws_lb_target_group.main.arn
}
