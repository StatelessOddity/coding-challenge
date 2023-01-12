variable "aws_region" {
    default = "us-east-1"
}

variable "rdx_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "rdx_vpc_subnet_count" {
  description = "Number of subnets for the VPC"
  type = map(number)
  default = {
    public = 1,
    private = 1
  }
}

variable "settings" {
  description = "Configuration for the EC2s and DB"
  type = map(any)
  default = {
    "database" = {
      allocated_storage = 10
      engine = "postgres"
      engine_version = "todo"
      instance_class = "db.t2.micro"
      db_name = 
    },
    "compute" = {
      count = 2
      instance_type = "t2.micro"
      name = {
        type = list(string)
        default = [ "Node" , "Gateway" ]
      }
    }
  }
}
#TODO: Settings for EC2s and RDS

variable "rdx_public_subnet_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX public subnets"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "rdx_private_subnet_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX private subnets"
  type = list(string)
  default = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24" ]
}

variable "db_username" {
  description = "Master user for the database"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Password for the database master user"
  type = string
  sensitive = true
}