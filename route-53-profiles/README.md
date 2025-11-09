# Route 53 Profiles Module

Route 53 profiles are basically a "box" you can throw your DNS bits into — private hosted zones, resolver rules, VPC endpoints, DNS firewall rules — and share them as a single unit across accounts and VPCs. Much simpler than managing hundreds of individual PHZ associations, though they do cost a bit ($0.75/hour for the first 100 VPC associations).

This module creates the profile, associates whatever DNS resources you want with it, and optionally shares it via RAM. If you're managing DNS at any kind of scale, or just want a cleaner way to centralize DNS configs, this is probably what you want.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53profiles_association.vpc_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_association) | resource |
| [aws_route53profiles_profile.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_profile) | resource |
| [aws_route53profiles_resource_association.dns_firewall_rule_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_resource_association) | resource |
| [aws_route53profiles_resource_association.private_hosted_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_resource_association) | resource |
| [aws_route53profiles_resource_association.resolver_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_resource_association) | resource |
| [aws_route53profiles_resource_association.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53profiles_resource_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_firewall_rule_groups"></a> [dns\_firewall\_rule\_groups](#input\_dns\_firewall\_rule\_groups) | Map of DNS firewall rule groups to associate with the Route 53 Profile. Provide either firewall\_rule\_group\_id (for same account) or resource\_arn (for cross-account). | <pre>map(object({<br>    firewall_rule_group_id = optional(string)<br>    resource_arn           = optional(string)<br>    priority               = number<br>  }))</pre> | `{}` | no |
| <a name="input_enable_ram_sharing"></a> [enable\_ram\_sharing](#input\_enable\_ram\_sharing) | Whether to share the Route 53 Profile via AWS Resource Access Manager (RAM). | `bool` | `false` | no |
| <a name="input_private_hosted_zones"></a> [private\_hosted\_zones](#input\_private\_hosted\_zones) | Map of Private Hosted Zones to associate with the Route 53 Profile. Provide either zone\_id (for same account) or resource\_arn (for cross-account). | <pre>map(object({<br>    zone_id      = optional(string)<br>    resource_arn = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_profile_name"></a> [profile\_name](#input\_profile\_name) | Name of the Route 53 Profile. | `string` | n/a | yes |
| <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals) | Whether to allow sharing with external principals (outside your organisation). | `bool` | `false` | no |
| <a name="input_ram_principals"></a> [ram\_principals](#input\_ram\_principals) | List of AWS account IDs or organization IDs to share the Route 53 Profile with via RAM (if `enable_ram_sharing` is `true`). | `set(string)` | `[]` | no |
| <a name="input_resolver_rules"></a> [resolver\_rules](#input\_resolver\_rules) | Map of resolver rules to associate with the Route 53 Profile. Provide either rule\_id (for same account) or resource\_arn (for cross-account). | <pre>map(object({<br>    rule_id      = optional(string)<br>    resource_arn = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources provisioned by this module. | `map(string)` | `{}` | no |
| <a name="input_vpc_associations"></a> [vpc\_associations](#input\_vpc\_associations) | Map of VPCs to associate with the Route 53 Profile. Each VPC must be in the same region as the profile. | <pre>map(object({<br>    vpc_id = string<br>  }))</pre> | `{}` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | Map of VPC endpoints to associate with the Route 53 Profile. Provide either vpc\_endpoint\_id (for same account) or resource\_arn (for cross-account). | <pre>map(object({<br>    vpc_endpoint_id = optional(string)<br>    resource_arn    = optional(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_profile_arn"></a> [profile\_arn](#output\_profile\_arn) | The ARN of the Route 53 Profile. |
| <a name="output_profile_id"></a> [profile\_id](#output\_profile\_id) | The ID of the Route 53 Profile. |
| <a name="output_profile_name"></a> [profile\_name](#output\_profile\_name) | The name of the Route 53 Profile. |
| <a name="output_ram_resource_share_arn"></a> [ram\_resource\_share\_arn](#output\_ram\_resource\_share\_arn) | The ARN of the RAM resource share (if enabled). |
<!-- END_TF_DOCS -->
