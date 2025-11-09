resource "aws_route53profiles_profile" "main" {
  name = var.profile_name

  tags = merge(var.tags, {
    Name = var.profile_name
  })
}

# Associate Private Hosted Zones with the profile
resource "aws_route53profiles_resource_association" "private_hosted_zones" {
  for_each = var.private_hosted_zones

  name        = "${var.profile_name}-phz-${each.key}"
  profile_id  = aws_route53profiles_profile.main.id
  resource_arn = each.value.resource_arn != null ? each.value.resource_arn : "arn:aws:route53:::hostedzone/${each.value.zone_id}"
}

# Associate resolver rules with the profile
resource "aws_route53profiles_resource_association" "resolver_rules" {
  for_each = var.resolver_rules

  name        = "${var.profile_name}-rule-${each.key}"
  profile_id  = aws_route53profiles_profile.main.id
  resource_arn = each.value.resource_arn != null ? each.value.resource_arn : "arn:aws:route53resolver:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:resolver-rule/${each.value.rule_id}"
}

# Associate VPC endpoints with the profile
resource "aws_route53profiles_resource_association" "vpc_endpoints" {
  for_each = var.vpc_endpoints

  name        = "${var.profile_name}-vpce-${each.key}"
  profile_id  = aws_route53profiles_profile.main.id
  resource_arn = each.value.resource_arn != null ? each.value.resource_arn : "arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:vpc-endpoint/${each.value.vpc_endpoint_id}"
}

# Associate DNS firewall rule groups with the profile
resource "aws_route53profiles_resource_association" "dns_firewall_rule_groups" {
  for_each = var.dns_firewall_rule_groups

  name                           = "${var.profile_name}-frg-${each.key}"
  profile_id                     = aws_route53profiles_profile.main.id
  resource_arn                   = each.value.resource_arn != null ? each.value.resource_arn : "arn:aws:route53resolver:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:firewall-rule-group/${each.value.firewall_rule_group_id}"
  resource_properties            = jsonencode({
    priority = each.value.priority
  })
}

# Associate VPCs with the profile
resource "aws_route53profiles_association" "vpc_associations" {
  for_each = var.vpc_associations

  name        = "${var.profile_name}-vpc-${each.key}"
  profile_id  = aws_route53profiles_profile.main.id
  resource_id = each.value.vpc_id
}
