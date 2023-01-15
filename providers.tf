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
  region = "us-east-1"
}

provider "github" {}