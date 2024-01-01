provider "aws" {
  region  = local.region
  profile = local.profile

  default_tags {
    tags = {
      environment = "dev"
      project     = "web-app-infra"
      application = "demo-app"
      repository  = "jayrahim/web-app-infra"
    }
  }
}