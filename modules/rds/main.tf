locals {
  default_app_cidrs = toset(["10.0.64.0/20", "10.0.80.0/20"])
  default_db_cidrs  = toset(["10.0.96.0/20", "10.0.112.0/20"])
}

resource "random_password" "rds_master_password" {
  length  = 16
  special = false
}

resource "random_string" "rds_master_username" {
  length  = 16
  special = false
  numeric = false
}

resource "aws_ssm_parameter" "rds_master_password_parameter" {
  name  = "/${var.project_name}/db/master_password"
  type  = "SecureString"
  value = random_password.rds_master_password.result

  tags = {
    Name = "${var.project_name}-db-master-password-param"
  }
}

resource "aws_ssm_parameter" "rds_master_username_parameter" {
  name  = "/${var.project_name}/db/master_username"
  type  = "SecureString"
  value = random_string.rds_master_username.result

  tags = {
    Name = "${var.project_name}-db-master-username-param"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = "8.0.35"
  instance_class              = var.rds_instance_class
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  backup_retention_period     = var.backup_retention_period
  db_subnet_group_name        = aws_db_subnet_group.rds_subnet_group.name
  identifier                  = var.db_name
  username                    = random_string.rds_master_username.result
  password                    = random_password.rds_master_password.result
  skip_final_snapshot         = true
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]

  tags = {
    Name = "${var.project_name}-db"
  }
}

resource "aws_security_group" "rds_sg" {
  description = "Security group for the RDS instance"
  name        = "${var.project_name}-db-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

resource "aws_security_group_rule" "allow_admin" {
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = ["137.83.0.0/16"]
  to_port           = 3306
  from_port         = 3306
  description       = "Allows access to the admin public IP address"
}

resource "aws_security_group_rule" "allow_app_subnets" {
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.rds_sg.id
  cidr_blocks       = length(var.app_cidrs) > 0 ? tolist(var.app_cidrs) : tolist(local.default_app_cidrs)
  to_port           = 3306
  from_port         = 3306
  description       = "Allows access to the app subnet"
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.project_name}-db-sub-group"
  subnet_ids  = var.db_subnet_ids
  description = "The subnet group for the RDS instance"

  tags = {
    Name = "${var.project_name}-db-sub-group"
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = "${aws_db_instance.rds.engine}-parameter-group-${replace("${aws_db_instance.rds.engine_version}", ".", "-")}"
  family      = "mysql8.0"
  description = "The parameter group for the RDS instance"

  tags = {
    Name = "${aws_db_instance.rds.engine}-parameter-group-${replace("${aws_db_instance.rds.engine_version}", ".", "-")}"
  }
}

resource "aws_db_option_group" "rds_option_group" {
  name                     = "${aws_db_instance.rds.engine}-option-group-${replace("${aws_db_instance.rds.engine_version}", ".", "-")}"
  option_group_description = "The option group for the RDS instance"
  major_engine_version     = var.major_engine_version
  engine_name              = aws_db_instance.rds.engine

  tags = {
    Name = "${aws_db_instance.rds.engine}-option-group-${replace("${aws_db_instance.rds.engine_version}", ".", "-")}"
  }
}