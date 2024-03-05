provider "aws" {
  region  = "us-east-1"
  profile = "lab"
}

module "s3" {
  source       = "../../"
  project_name = var.project_name
}