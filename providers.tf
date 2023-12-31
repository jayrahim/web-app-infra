provider "aws" {
  region  = local.region
  profile = local.profile

  default_tags {
    tags = {
      environment = "dev"
      project     = "web-hosting-infrastructure"
      application = "demo-app"
      repository  = "jayrahim/web-hosting-infra"
    }
  }
}