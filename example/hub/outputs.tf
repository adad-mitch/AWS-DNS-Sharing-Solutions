output "hub_vpc_id" {
  description = "ID of the Hub VPC."
  value       = aws_vpc.hub.id
}

output "inbound_resolver_ips" {
  description = "IP addresses of the inbound resolver endpoints."
  value       = module.inbound_resolver.resolver_endpoint_ip_addresses
}

output "hosted_zone_id" {
  description = "ID of the example private hosted zone."
  value       = aws_route53_zone.example.zone_id
}
