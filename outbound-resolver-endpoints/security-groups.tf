resource "aws_security_group" "resolver_endpoint" {
  name_prefix = "${var.name_prefix}-resolver-endpoint-"
  description = "Security group for Route 53 Resolver outbound endpoint"
  vpc_id      = var.vpc_id

  # Dynamic ingress rules for allowing queries from specified sources
  dynamic "ingress" {
    for_each = local.sg_ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      description     = ingress.value.description
      cidr_blocks     = var.allowed_cidr_blocks
      security_groups = var.allowed_security_groups
    }
  }

  # Dynamic egress rules for forwarding queries to target DNS servers
  dynamic "egress" {
    for_each = local.sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-resolver-endpoint-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}
