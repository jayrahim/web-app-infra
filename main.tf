module "networking" {
  source       = "./modules/networking"
  vpc_cidr     = "172.16.0.0/16"
  public_cidrs = ["172.16.0.0/19", "172.16.32.0/19"]
  web_cidrs    = ["172.16.64.0/19", "172.16.96.0/19"]
  app_cidrs    = ["172.16.128.0/19", "172.16.160.0/19"]
  db_cidrs     = ["172.16.192.0/19", "172.16.224.0/19"]
}