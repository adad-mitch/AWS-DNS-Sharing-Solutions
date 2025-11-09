output "spoke_vpc_id" {
  description = "ID of the Spoke VPC."
  value       = aws_vpc.spoke.id
}

output "peering_connection_id" {
  description = "ID of the VPC peering connection."
  value       = aws_vpc_peering_connection.spoke_to_hub.id
}

output "lambda_function_name" {
  description = "Name of the DNS test Lambda function."
  value       = aws_lambda_function.dns_test.function_name
}

output "dns_profile_id" {
  description = "ID of the Route 53 profile"
  value       = var.provision_dns_profile ? module.dns_profile[0].profile_id : null
}
