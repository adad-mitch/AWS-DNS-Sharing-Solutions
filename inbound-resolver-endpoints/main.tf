resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "${var.name_prefix}-inbound-endpoint"
  direction = "INBOUND"
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
    Name = "${var.name_prefix}-inbound-endpoint"
  })
}
