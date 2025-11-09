# Optional: Share via RAM
resource "aws_ram_resource_share" "profile" {
  count = var.enable_ram_sharing ? 1 : 0
  
  name                      = "${var.profile_name}-profile-share"
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(var.tags, {
    Name = "${var.profile_name}-profile-share"
  })
}

resource "aws_ram_resource_association" "profile" {
  count = var.enable_ram_sharing ? 1 : 0
  
  resource_arn       = aws_route53profiles_profile.main.arn
  resource_share_arn = aws_ram_resource_share.profile[0].arn
}

resource "aws_ram_principal_association" "profile" {
  for_each = var.enable_ram_sharing ? var.ram_principals : toset([])
  
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.profile[0].arn
}