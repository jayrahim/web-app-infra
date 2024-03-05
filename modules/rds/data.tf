data "aws_subnets" "db_subnets" {
  filter {
    name   = "tag:Name"
    values = ["db-sub"]
  }
}