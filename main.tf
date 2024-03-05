module "networking" {
  source = "./modules/networking"
}

module "efs" {
  source         = "./modules/efs"
  vpc_id         = module.networking.vpc_id
  app_subnet_ids = module.networking.app_subnet_ids
}

module "rds" {
  source                  = "./modules/rds"
  major_engine_version    = "8.0"
  db_subnet_ids           = module.networking.db_subnet_ids
  vpc_id                  = module.networking.vpc_id
  engine                  = "mysql"
  db_name                 = "web-app-infra-db"
  backup_retention_period = 3
}

module "redis" {
  source               = "./modules/redis"
  redis_subnet_ids     = module.networking.cache_subnet_ids
  replication_group_id = "web-app-infra-replication-group"
  vpc_id               = module.networking.vpc_id
  project_name         = "web-app-infra"
}

module "s3" {
  source       = "./modules/s3"
  project_name = "web-app-infra"
}