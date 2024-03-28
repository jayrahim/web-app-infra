provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "networking" {
  source = "../../../networking"
}

module "application" {
  source            = "../../"
  app_lb_name       = var.app_lb_name
  web_server_prefix = var.web_server_prefix
  app_server_prefix = var.app_server_prefix
  public_subnet_ids = module.networking.app_subnet_ids
  web_subnet_ids    = module.networking.web_subnet_ids
  vpc_id            = module.networking.vpc_id
  app_subnet_ids    = module.networking.app_subnet_ids
}