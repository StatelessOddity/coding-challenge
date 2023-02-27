variable "aws_region" {
  default = "us-east-1"
}

variable "rdx_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "rdx_subnet_count" {
  description = "Number of subnets for the VPC"
  type        = map(number)
  default = {
    rdx_stack = 1,
    database  = 2
  }
}

variable "full_node" {
  description = "Configuration of the full node EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "data_aggregator" {
  description = "Configuration of the data aggregator EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "gateway_api" {
  description = "Configuration of the Network Gateway EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "rdx_stack_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "database_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
}

variable "rdx_stack_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow HTTPS traffic"
    },
    {
      from_port   = 30000
      to_port     = 30000
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow traffic on port 30000"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow SSH traffic"
    },
  ]
}

variable "rdx_stack_egress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    },
  ]
}


variable "database_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow PostgreSQL traffic"
    },
  ]
}

# Public key for accessing EC2s:
variable "rdx_public_key" {
  sensitive = true
}

# Private key for accessing EC2s
variable "rdx_private_key" {
  sensitive = true
}

# Personal Github tokens:
variable "token_github" {
  sensitive = true
}