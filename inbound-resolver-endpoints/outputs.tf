output "resolver_endpoint_id" {
  description = "The ID of the Route 53 Resolver inbound endpoint."
  value       = aws_route53_resolver_endpoint.inbound.id
}

output "resolver_endpoint_arn" {
  description = "The ARN of the Route 53 Resolver inbound endpoint."
  value       = aws_route53_resolver_endpoint.inbound.arn
}

output "resolver_endpoint_ip_addresses" {
  description = "List of IP addresses assigned to the resolver endpoint."
  value       = [for ip in aws_route53_resolver_endpoint.inbound.ip_address : ip.ip]
}

output "security_group_id" {
  description = "The ID of the security group created for the resolver endpoint."
  value       = aws_security_group.resolver_endpoint.id
}

output "ram_resource_share_arn" {
  description = "The ARN of the RAM resource share (if enabled)."
  value       = var.enable_ram_sharing ? aws_ram_resource_share.resolver_endpoint[0].arn : null
}


