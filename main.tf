provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-demo-tfstate-files"
    key    = "dev/terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-tfstate-lock"
    encrypt = true
  }
}

module "dev" {
  source = "./environments/dev"
}
