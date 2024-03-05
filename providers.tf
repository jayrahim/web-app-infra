provider "aws" {
  region  = local.region
  profile = local.profile

  default_tags {
    tags = {
      environment = "lab"
      project     = "web-app-infra-architecture"
      application = "demo-app"
      repository  = "jayrahim/web-app-infra"
    }
  }
}