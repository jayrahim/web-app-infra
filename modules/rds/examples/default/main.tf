provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "networking" {
  source = "../../../networking"
}

module "rds" {
  source                  = "../../"
  vpc_id                  = module.networking.vpc_id
  db_subnet_ids           = module.networking.db_subnet_ids
  engine                  = var.engine
  major_engine_version    = var.major_engine_version
  backup_retention_period = var.backup_retention_period
  db_name                 = var.db_name
  project_name            = var.project_name
}