variable "aws_region" {
  default = "us-east-1"
}

variable "rdx_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets for the VPC"
  type        = map(number)
  default = {
    bastion   = 1,
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
    public_ip     = true
  }
}

variable "data_aggregator" {
  description = "Configuration of the data aggregator EC2 instance. Currently only one is supported."
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
    public_ip     = true
  }
}

variable "gateway_api" {
  description = "Configuration of the Network Gateway EC2 instance"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
    public_ip     = true
  }
}

variable "monitoring" {
  description = "Configuration of the monitoring"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
    public_ip     = true
  }
}

variable "bastion" {
  description = "Configuration of the Bastion"
  type        = map(any)
  default = {
    instance_type = "t3.micro"
    count         = 1
    public_ip     = false
  }
}

variable "bastion_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "rdx_stack_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX public subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
}

variable "database_cidr_blocks" {
  description = "Avalible CIRD blocks for RDX private subnets"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24", "10.0.24.0/24"]
}

variable "bastion_web_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow SSH traffic"
    },
    {
      from_port   = 5900
      to_port     = 5900
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow VNC traffic"
    },
  ]
}

variable "bastion_egress" {
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

variable "rdx_stack_web_ingress" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 30000
      to_port     = 30000
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "GOSSIP port for node to node communication"
    },
  ]
}

variable "rdx_stack_bastion_ingress" {
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
      description = "API endpoints"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
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

variable "rdx_public_key" {
  sensitive = true
}

variable "rdx_private_key" {
  sensitive = true
}

variable "token_github" {
  sensitive = true
}

variable "rdx_password" {
  sensitive = true
}