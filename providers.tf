terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  } 
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "github" {}