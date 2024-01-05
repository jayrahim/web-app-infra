module "networking" {
  source       = "./modules/networking"
  vpc_cidr     = "172.16.0.0/16"
  public_cidrs = ["172.16.0.0/19", "172.16.32.0/19"]
  web_cidrs    = ["172.16.64.0/19", "172.16.96.0/19"]
  app_cidrs    = ["172.16.128.0/19", "172.16.160.0/19"]
  db_cidrs     = ["172.16.192.0/19", "172.16.224.0/19"]
}

module "data" {
  source                  = "./modules/data"
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "msyql8.0.5"
  backup_retention_period = 1
  db_subnet_ids           = module.networking.db_subnet_ids
  major_engine_version    = "8.0"
  vpc_id                  = module.networking.vpc_id
  app_subnet_id           = module.networking.app_subnet_ids[0]
}