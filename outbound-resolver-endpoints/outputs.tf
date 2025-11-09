output "resolver_endpoint_id" {
  description = "The ID of the Route 53 Resolver outbound endpoint."
  value       = aws_route53_resolver_endpoint.outbound.id
}

output "resolver_endpoint_arn" {
  description = "The ARN of the Route 53 Resolver outbound endpoint."
  value       = aws_route53_resolver_endpoint.outbound.arn
}

output "resolver_endpoint_ip_addresses" {
  description = "List of IP addresses assigned to the resolver endpoint."
  value       = [for ip in aws_route53_resolver_endpoint.outbound.ip_address : ip.ip]
}

output "security_group_id" {
  description = "The ID of the security group created for the resolver endpoint."
  value       = aws_security_group.resolver_endpoint.id
}

output "ram_resource_share_arn" {
  description = "The ARN of the RAM resource share (if enabled)."
  value       = var.enable_ram_sharing ? aws_ram_resource_share.resolver_endpoint[0].arn : null
}

output "resolver_rules" {
  description = "Map of resolver rules created for domain forwarding."
  value = {
    for rule_name, rule in aws_route53_resolver_rule.forwarding_rules : rule_name => {
      id          = rule.id
      arn         = rule.arn
      domain_name = rule.domain_name
      rule_type   = rule.rule_type
      target_ips  = var.resolver_rules[rule_name].target_ips
    }
  }
}


