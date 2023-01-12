terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  } 
#  backend "s3" {
#    region = "us-east-1"
#    key    = "terraform.tfstate"
#  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {}

resource "aws_vpc" "rdx_vpc" {
  cidr_block = var.rdx_vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "RDX VPC"
  }
}

resource "aws_internet_gateway" "rdx_internet_gateway" {
  vpc_id = aws_vpc.rdx_vpc.id
  tags = {
    Name = "RXD Internet Gateway"
  }
}

resource "aws_subnet" "rdx_public_subnet" {
  count = var.rdx_vpc_subnet_count.public
  vpc_id = aws_vpc.rdx_vpc.id
  cidr_block = var.rdx_public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_avalibility_zones.avalible.names[count.index]
  tags = {
    Name = "RDX public subnet"
  }
}

resource "aws_subnet" "rdx_private_subnet" {
  count = var.rdx_vpc_subnet_count.private
  vpc_id = aws_vpc.rdx_vpc.id
  cidr_block = var.rdx_private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_avalibility_zones.avalible.names[count.index]
  tags = {
    Name = "RDX private sunet $(count.index)"
  }
}

resource "github_action_secret" "example_secret" {
  
}