resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

######################################################
# Web Server Instance Profile
######################################################

resource "aws_iam_role" "web_server_role" {
  name               = "${var.web_server_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "web_server_profile" {
  name = "${var.web_server_prefix}-instance-profile"
  role = aws_iam_role.web_server_role.name
}

resource "aws_iam_policy_attachment" "ec2_web" {
  name       = "${var.web_server_prefix}-ec2-read-only-attachment"
  roles      = [aws_iam_role.web_server_role.name]
  policy_arn = data.aws_iam_policy.ec2.arn
}

resource "aws_iam_policy_attachment" "ssm_web" {
  name       = "${var.web_server_prefix}-ssm-attachment"
  roles      = [aws_iam_role.web_server_role.name]
  policy_arn = data.aws_iam_policy.ssm.arn
}

######################################################
# Web Server LB and Associated Resources
######################################################

resource "aws_security_group" "web_load_balancer_sg" {
  description = "The security group for the public facing load balancer"
  name        = "${var.web_server_prefix}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.web_server_prefix}-sg"
  }
}

resource "aws_security_group_rule" "allow_http_from_anywhere" {
  description       = "Allows HTTP from internet"
  type              = "ingress"
  security_group_id = aws_security_group.web_load_balancer_sg.id
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_to_anywhere" {
  description       = "Allows HTTP anywhere"
  type              = "egress"
  security_group_id = aws_security_group.web_load_balancer_sg.id
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_to_anywhere" {
  description       = "Allows HTTPs to internet"
  type              = "egress"
  security_group_id = aws_security_group.web_load_balancer_sg.id
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "web_lb" {
  name               = "${var.web_server_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_load_balancer_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.web_server_prefix}-lb"
  }
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_load_balancer_tg.arn
  }

  tags = {
    Name = "${var.web_server_prefix}-listener"
  }
}

resource "aws_lb_target_group" "web_load_balancer_tg" {
  name        = "${var.web_server_prefix}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP" # must be capitalized
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold = 2
    path              = "/health"
    interval          = 30
  }

  tags = {
    Name = "${var.web_server_prefix}-tg"
  }
}

######################################################
# Web Server ASG and Associated Resources
######################################################

resource "aws_security_group" "web_launch_template_sg" {
  description = "The security group for the web launch template"
  name        = "${var.web_server_prefix}-launch-template-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.web_server_prefix}-launch-template-sg"
  }
}

resource "aws_security_group_rule" "allow_health_check_from_web_lb" {
  description              = "Allows HTTP from web load balancer"
  type                     = "ingress"
  security_group_id        = aws_security_group.web_launch_template_sg.id
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_load_balancer_sg.id
}

resource "aws_security_group_rule" "allow_http_to_internet_from_web_server" {
  description       = "Allows HTTP to internet"
  type              = "egress"
  security_group_id = aws_security_group.web_launch_template_sg.id
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allows_https_to_internet_from_web_server" {
  description       = "Allows HTTPS to internet"
  type              = "egress"
  security_group_id = aws_security_group.web_launch_template_sg.id
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "allow_port_5000_to_app_lb" {
  description              = "Allows HTTP egress"
  type                     = "egress"
  security_group_id        = aws_security_group.web_launch_template_sg.id
  to_port                  = 5000
  from_port                = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_load_balancer_sg.id
}

resource "aws_launch_template" "web_asg_launch_template" {
  description   = "The launch template for the web auto scaling group"
  name          = "${var.web_server_prefix}-asg-launch-template"
  image_id      = data.aws_ami.selected.id
  instance_type = "t2.micro"

  user_data = base64encode(templatefile("${path.module}/userdata/web_userdata.sh", {
    app_lb_name  = var.app_lb_name,
    region       = var.region,
    backend_port = var.backend_port
  }))

  vpc_security_group_ids = [aws_security_group.web_launch_template_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.web_server_profile.name
  }

  tags = {
    Name = "${var.web_server_prefix}-asg-launch-template"
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
  name                      = "${var.web_server_prefix}-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.web_load_balancer_tg.id]
  depends_on                = [aws_lb.app_lb]

  launch_template {
    id      = aws_launch_template.web_asg_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.web_subnet_ids

  instance_maintenance_policy {
    min_healthy_percentage = 50
    max_healthy_percentage = 150
  }

  tag {
    key                 = "Name"
    value               = "nginx-${var.web_server_prefix}-${random_string.random.result}"
    propagate_at_launch = true
  }
}

######################################################
# App Server Instance Profile
######################################################

resource "aws_iam_role" "app_server_role" {
  name               = "${var.app_server_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "app_server_profile" {
  name = "${var.app_server_prefix}-instance-profile"
  role = aws_iam_role.app_server_role.name
}

resource "aws_iam_policy_attachment" "ssm_app" {
  name       = "${var.app_server_prefix}-ssm-attachment"
  roles      = [aws_iam_role.app_server_role.name]
  policy_arn = data.aws_iam_policy.ssm.arn
}

######################################################
# App LB and Associated Resources
######################################################

resource "aws_security_group" "app_load_balancer_sg" {
  description = "The security group for the app load balancer"
  name        = "${var.app_server_prefix}-lb-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.app_server_prefix}-lb-sg"
  }
}

resource "aws_security_group_rule" "allow_port_5000_from_web_sg" {
  description              = "Allows HTTP 5000 from the web security group"
  type                     = "ingress"
  security_group_id        = aws_security_group.app_load_balancer_sg.id
  to_port                  = 5000
  from_port                = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_launch_template_sg.id
}

resource "aws_security_group_rule" "app_health_check_probing" {
  description              = "Allows HTTP"
  type                     = "egress"
  security_group_id        = aws_security_group.app_load_balancer_sg.id
  to_port                  = 5000
  from_port                = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_launch_template_sg.id
}


resource "aws_lb" "app_lb" {
  name               = var.app_lb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_load_balancer_sg.id]
  subnets            = var.app_subnet_ids
  internal           = true

  tags = {
    Name = "${var.app_lb_name}"
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_load_balancer_tg.arn
  }

  tags = {
    Name = "${var.app_server_prefix}-lb-listener"
  }
}

resource "aws_lb_target_group" "app_load_balancer_tg" {
  name        = "${var.app_server_prefix}-tg"
  target_type = "instance"
  port        = 5000
  protocol    = "HTTP" # must be capitalized
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold = 2
    interval          = 30
    path              = "/health"
  }

  tags = {
    Name = "${var.app_server_prefix}-tg"
  }
}

######################################################
# App ASG and Associated Resources
######################################################

resource "aws_security_group" "app_launch_template_sg" {
  description = "The security group for the app launch template"
  name        = "${var.app_server_prefix}-launch-template-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.app_server_prefix}-launch-template-sg"
  }
}

resource "aws_security_group_rule" "allow_health_check_probing" {
  description              = "Allows HTTP"
  type                     = "ingress"
  security_group_id        = aws_security_group.app_launch_template_sg.id
  to_port                  = 5000
  from_port                = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_load_balancer_sg.id
}

resource "aws_security_group_rule" "allow_https_from_app_sg" {
  description       = "Allows HTTPs"
  type              = "egress"
  security_group_id = aws_security_group.app_launch_template_sg.id
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_from_app_sg" {
  description       = "Allows HTTP"
  type              = "egress"
  security_group_id = aws_security_group.app_launch_template_sg.id
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_launch_template" "app_launch_template" {
  description            = "The launch template for the app auto scaling group"
  name                   = "${var.app_server_prefix}-asg-launch-template"
  image_id               = data.aws_ami.selected.id
  instance_type          = "t2.micro"
  user_data              = filebase64("${path.module}/userdata/app_userdata.sh")
  vpc_security_group_ids = [aws_security_group.app_launch_template_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.app_server_profile.name
  }

  tags = {
    Name = "${var.app_server_prefix}-asg-launch-templatee"
  }
}

resource "aws_autoscaling_group" "app_server_asg" {
  name                      = "${var.app_server_prefix}-asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  target_group_arns         = [aws_lb_target_group.app_load_balancer_tg.id]

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.app_subnet_ids

  instance_maintenance_policy {
    min_healthy_percentage = 50
    max_healthy_percentage = 150
  }

  tag {
    key                 = "Name"
    value               = "flask-app-${var.app_server_prefix}-${random_string.random.result}"
    propagate_at_launch = true
  }
}