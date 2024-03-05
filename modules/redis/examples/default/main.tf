provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "networking" {
  source = "../../../networking"
}

module "redis" {
  source               = "../../"
  vpc_id               = module.networking.vpc_id
  redis_subnet_ids     = module.networking.cache_subnet_ids
  replication_group_id = var.replication_group_id
  project_name         = var.project_name
}