variable "aws_region" {
  default = "us-east-1"
}

variable "rdx_vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "rdx_vpc_subnet_count" {
  description = "Number of subnets for the VPC"
  type        = map(number)
  default = {
    public  = 1,
    private = 2
  }
}

variable "full_node_ec2" {
  description = "Configuration of the full node EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "data_aggregator_ec2" {
  description = "Configuration of the data aggregator EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "gateway_api_ec2" {
  description = "Configuration of the Network Gateway EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
  }
}

variable "rdx_public_subnet_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "rdx_private_subnet_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
}

variable "public_security_group_rules_ingress" {
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

variable "public_security_group_rules_egress" {
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


variable "private_security_group_rules" {
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

# Public key for accessing EC2s
variable "rdx_public_key" {
  sensitive = true
}

# Public key for accessing EC2s
variable "rdx_private_key" {
  sensitive = true
}

# Personal Github token
variable "token_github" {
  sensitive = true
}