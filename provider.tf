// Declare Terraform providers to be used
terraform {
  required_version = ">= 1.4.0"
}

provider "aws" {
  region = var.region
}