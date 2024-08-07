provider "aws" {
  region = "eu-north-1"
}

module "dev" {
  source = "./environments/dev"
}
