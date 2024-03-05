provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "networking" {
  source = "../../../networking"
}

module "efs" {
  source         = "../.."
  vpc_id         = module.networking.vpc_id
  project_name   = var.project_name
  app_subnet_ids = module.networking.app_subnet_ids
}