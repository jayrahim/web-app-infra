resource "aws_security_group" "efs_sg" {
  name        = "${var.project_name}-efs-sg"
  description = "Security group to control access to EFS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-efs-sg"
  }
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
  creation_token  = "${var.project_name}-efs-fs"
  encrypted       = true
  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.project_name}-efs-fs"
  }
}

resource "aws_efs_mount_target" "efs_mount_targets" {
  count           = length(var.app_subnet_ids)
  file_system_id  = aws_efs_file_system.efs_fs.id
  subnet_id       = var.app_subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}