#################################################################
# Bastion
#################################################################

resource "aws_security_group" "bastion" {
  name        = "Bastion"
  description = "Security group for Bastion subnet"
  vpc_id      = aws_vpc.rdx.id
}

resource "aws_security_group_rule" "bastion_ingress_web" {
  count             = length(var.bastion_web_ingress)
  type              = "ingress"
  from_port         = var.bastion_web_ingress[count.index].from_port
  to_port           = var.bastion_web_ingress[count.index].to_port
  protocol          = var.bastion_web_ingress[count.index].protocol
  cidr_blocks       = [var.bastion_web_ingress[count.index].cidr_block]
  description       = var.bastion_web_ingress[count.index].description
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress" {
  count             = length(var.bastion_egress)
  type              = "egress"
  from_port         = var.bastion_egress[count.index].from_port
  to_port           = var.bastion_egress[count.index].to_port
  protocol          = var.bastion_egress[count.index].protocol
  cidr_blocks       = [var.bastion_egress[count.index].cidr_block]
  description       = var.bastion_egress[count.index].description
  security_group_id = aws_security_group.bastion.id
}

#################################################################
# RDX Stack
#################################################################

resource "aws_security_group" "rdx_stack" {
  name        = "rdx_stack"
  description = "Security for compute EC2 instances of Full Node, Gateway and monitoring"
  vpc_id      = aws_vpc.rdx.id
}

resource "aws_security_group_rule" "rdx_stack_web_ingress" {
  count             = length(var.rdx_stack_web_ingress)
  type              = "ingress"
  from_port         = var.rdx_stack_web_ingress[count.index].from_port
  to_port           = var.rdx_stack_web_ingress[count.index].to_port
  protocol          = var.rdx_stack_web_ingress[count.index].protocol
  cidr_blocks       = [var.rdx_stack_web_ingress[count.index].cidr_block]
  description       = var.rdx_stack_web_ingress[count.index].description
  security_group_id = aws_security_group.rdx_stack.id
}

resource "aws_security_group_rule" "rdx_stack_bastion_ingress" {
  count                    = length(var.rdx_stack_bastion_ingress)
  type                     = "ingress"
  from_port                = var.rdx_stack_bastion_ingress[count.index].from_port
  to_port                  = var.rdx_stack_bastion_ingress[count.index].to_port
  protocol                 = var.rdx_stack_bastion_ingress[count.index].protocol
  description              = var.rdx_stack_bastion_ingress[count.index].description
  security_group_id        = aws_security_group.rdx_stack.id
  source_security_group_id = aws_security_group.rdx_stack.id
}

resource "aws_security_group_rule" "rdx_stack_egress" {
  count             = length(var.rdx_stack_egress)
  type              = "egress"
  from_port         = var.rdx_stack_egress[count.index].from_port
  to_port           = var.rdx_stack_egress[count.index].to_port
  protocol          = var.rdx_stack_egress[count.index].protocol
  cidr_blocks       = [var.rdx_stack_egress[count.index].cidr_block]
  description       = var.rdx_stack_egress[count.index].description
  security_group_id = aws_security_group.rdx_stack.id
}

#################################################################
# Database
#################################################################

resource "aws_security_group" "database" {
  name        = "database"
  description = "security group for the database"
  vpc_id      = aws_vpc.rdx.id
}

resource "aws_security_group_rule" "database_stack_ingress" {
  count                    = length(var.database_ingress)
  type                     = "ingress"
  description              = var.database_ingress[count.index].description
  from_port                = var.database_ingress[count.index].from_port
  to_port                  = var.database_ingress[count.index].to_port
  protocol                 = var.database_ingress[count.index].protocol
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.rdx_stack.id
}

resource "aws_security_group_rule" "database_bastion_ingress" {
  count                    = length(var.database_ingress)
  type                     = "ingress"
  description              = var.database_ingress[count.index].description
  from_port                = var.database_ingress[count.index].from_port
  to_port                  = var.database_ingress[count.index].to_port
  protocol                 = var.database_ingress[count.index].protocol
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.bastion.id
}

#################################################################
# Keypairs
#################################################################

resource "aws_key_pair" "rdx_key" {
  key_name   = "rdx-key"
  public_key = var.rdx_public_key
}