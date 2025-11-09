# Optional: Share via RAM
resource "aws_ram_resource_share" "resolver_endpoint" {
  count = var.enable_ram_sharing ? 1 : 0
  
  name                      = "${var.name_prefix}-resolver-endpoint-share"
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-resolver-endpoint-share"
  })
}

resource "aws_ram_resource_association" "resolver_endpoint" {
  count = var.enable_ram_sharing ? 1 : 0
  
  resource_arn       = aws_route53_resolver_endpoint.inbound.arn
  resource_share_arn = aws_ram_resource_share.resolver_endpoint[0].arn
}

resource "aws_ram_principal_association" "resolver_endpoint" {
  for_each = var.enable_ram_sharing ? var.ram_principals : toset([])
  
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver_endpoint[0].arn
}
