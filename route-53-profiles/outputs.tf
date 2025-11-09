output "profile_id" {
  description = "The ID of the Route 53 Profile."
  value       = aws_route53profiles_profile.main.id
}

output "profile_arn" {
  description = "The ARN of the Route 53 Profile."
  value       = aws_route53profiles_profile.main.arn
}

output "profile_name" {
  description = "The name of the Route 53 Profile."
  value       = aws_route53profiles_profile.main.name
}

output "ram_resource_share_arn" {
  description = "The ARN of the RAM resource share (if enabled)."
  value       = var.enable_ram_sharing ? aws_ram_resource_share.profile[0].arn : null
}
