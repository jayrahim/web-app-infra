provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "networking" {
  source       = "../../"
  vpc_cidr     = "10.1.0.0/16"
  public_cidrs = ["10.1.0.0/24", "10.1.1.0/24"]
  web_cidrs    = ["10.1.2.0/24", "10.1.3.0/24"]
  app_cidrs    = ["10.1.4.0/24", "10.1.5.0/24"]
  db_cidrs     = ["10.1.6.0/24", "10.1.7.0/24"]
}