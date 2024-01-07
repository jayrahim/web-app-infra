resource "random_password" "rds_master_password" {
  length  = 16
  special = false
}

resource "random_string" "rds_master_username" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "rds_master_password_parameter" {
  name  = "/web-app-infra/db/master_password"
  type  = "SecureString"
  value = random_password.rds_master_password.result

  tags = {
    Name = "web-app-infra-db-master-password-param"
  }
}

resource "aws_ssm_parameter" "rds_master_username_parameter" {
  name  = "/web-app-infra/db/master_username"
  type  = "SecureString"
  value = random_string.rds_master_username.result

  tags = {
    Name = "web-app-infra-db-master-username-param"
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
  identifier                  = "web-app-infra-db"
  username                    = random_string.rds_master_username.result
  password                    = random_password.rds_master_password.result
  skip_final_snapshot         = true

  tags = {
    Name = "web-app-infra-db"
  }
}

resource "aws_security_group" "rds_sg" {
  description = "Security group for the ${aws_db_instance.rds.identifier} RDS instance"
  name        = "web-app-infra-db-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web-app-infra-db-sg"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "web-app-infra-db-sub-group"
  subnet_ids  = var.db_subnet_ids
  description = "The subnet group for the RDS instance"

  tags = {
    Name = "web-app-infra-db-sub-group"
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

resource "aws_security_group" "efs_sg" {
  name        = "web-app-infra-efs-sg"
  description = "Security group to control access to EFS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "web-app-infra-efs-sg"
  }
}

resource "aws_security_group_rule" "https" {
  description       = "Allows https outbound anywhere"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.efs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_nfs" {
  description       = "Allows port 2409 from the app security group"
  from_port         = 2409
  to_port           = 2409
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.efs_sg.id
  cidr_blocks       = ["0.0.0.0/0"] # Must be changed when the app security group is created
}

resource "aws_efs_file_system" "efs_fs" {
  creation_token  = "web-app-infra-efs-fs"
  encrypted       = true
  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "web-app-infra-efs-fs"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs_fs.id
  subnet_id       = var.app_subnet_id
  security_groups = [aws_security_group.efs_sg.id]
}