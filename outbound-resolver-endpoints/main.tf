resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "${var.name_prefix}-outbound-endpoint"
  direction = "OUTBOUND"
  protocols = var.protocols

  security_group_ids = [
    aws_security_group.resolver_endpoint.id
  ]

  # Create IP configurations for each subnet
  dynamic "ip_address" {
    for_each = var.resolver_subnets
    content {
      subnet_id = ip_address.value.subnet_id
      ip        = ip_address.value.ip_address
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-outbound-endpoint"
  })
}

# Optional resolver rules to forward queries for specific domains
resource "aws_route53_resolver_rule" "forwarding_rules" {
  for_each = var.resolver_rules

  domain_name          = each.value.domain_name
  name                 = "${var.name_prefix}-${each.key}-rule"
  rule_type            = each.value.rule_type
  resolver_endpoint_id = each.value.rule_type == "FORWARD" ? aws_route53_resolver_endpoint.outbound.id : null

  # Target IP addresses for FORWARD rules
  dynamic "target_ip" {
    for_each = each.value.rule_type == "FORWARD" ? each.value.target_ips : []
    content {
      ip   = target_ip.value.ip
      port = target_ip.value.port
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}-rule"
  })
}

resource "aws_route53_resolver_rule_association" "vpc_associations" {
  for_each = var.resolver_rules

  resolver_rule_id = aws_route53_resolver_rule.forwarding_rules[each.key].id
  vpc_id           = var.vpc_id
}
