resource "aws_security_group" "rdx_public_security_group" {
  name = "rdx_public_security_group"
  description = "Security for compute EC2 instances of Full Node, Gateway and monitoring"
  vpc_id = aws_vpc.rdx_vpc.id
}

resource "aws_security_group_rule" "rdx_public_security_group_rules_ingress" {
  count = length(var.public_security_group_rules_ingress)
  type              = "ingress"
  from_port         = var.public_security_group_rules_ingress[count.index].from_port
  to_port           = var.public_security_group_rules_ingress[count.index].to_port
  protocol          = var.public_security_group_rules_ingress[count.index].protocol
  cidr_blocks       = [var.public_security_group_rules_ingress[count.index].cidr_block]
  description       = var.public_security_group_rules_ingress[count.index].description
  security_group_id = aws_security_group.rdx_public_security_group.id
}

resource "aws_security_group_rule" "rdx_public_security_group_rules_engress" {
  count = length(var.public_security_group_rules_engress)
  type              = "engress"
  from_port         = var.public_security_group_rules_engress[count.index].from_port
  to_port           = var.public_security_group_rules_engress[count.index].to_port
  protocol          = var.public_security_group_rules_engress[count.index].protocol
  cidr_blocks       = [var.public_security_group_rules_engress[count.index].cidr_block]
  description       = var.public_security_group_rules_engress[count.index].description
  security_group_id = aws_security_group.rdx_public_security_group.id
}

resource "aws_security_group" "rdx_private_security_group" {
  name = "rdx_private_security_group"
  description = "security group for the Gateway API PostgreSQL Database"
  vpc_id = aws_vpc.rdx_vpc.id
}

resource "aws_security_group_rule" "rdx_private_security_group_rules" {
  count = length(var.private_security_group_rules)
  type = "ingress"
  description = var.private_security_group_rules[count.index].description
  from_port = var.private_security_group_rules[count.index].from_port
  to_port = var.private_security_group_rules[count.index].to_port
  protocol = var.private_security_group_rules[count.index].protocol
  security_group_id = aws_security_group.rdx_private_security_group.id
  source_security_group_id = aws_security_group.rdx_public_security_group.id
}