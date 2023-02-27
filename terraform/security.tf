resource "aws_security_group" "rdx_stack" {
  name        = "rdx_stack"
  description = "Security for compute EC2 instances of Full Node, Gateway and monitoring"
  vpc_id      = aws_vpc.rdx.id
}

resource "aws_security_group_rule" "rdx_stack_ingress" {
  count             = length(var.rdx_stack_ingress)
  type              = "ingress"
  from_port         = var.rdx_stack_ingress[count.index].from_port
  to_port           = var.rdx_stack_ingress[count.index].to_port
  protocol          = var.rdx_stack_ingress[count.index].protocol
  cidr_blocks       = [var.rdx_stack_ingress[count.index].cidr_block]
  description       = var.rdx_stack_ingress[count.index].description
  security_group_id = aws_security_group.rdx_stack.id
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

resource "aws_security_group" "database" {
  name        = "database"
  description = "security group for the Gateway API PostgreSQL Database"
  vpc_id      = aws_vpc.rdx.id
}

resource "aws_security_group_rule" "database_ingress" {
  count                    = length(var.database_ingress)
  type                     = "ingress"
  description              = var.database_ingress[count.index].description
  from_port                = var.database_ingress[count.index].from_port
  to_port                  = var.database_ingress[count.index].to_port
  protocol                 = var.database_ingress[count.index].protocol
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.rdx_stack.id
}

resource "aws_key_pair" "rdx_key" {
  key_name   = "rdx-key"
  public_key = var.rdx_public_key
}