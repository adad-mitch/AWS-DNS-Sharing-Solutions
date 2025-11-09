# Spoke Account DNS Infrastructure

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns_profile"></a> [dns\_profile](#module\_dns\_profile) | ../../route-53-profiles | n/a |

## Resources

| Name | Type |
|------|------|
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/resources/file) | resource |
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.dns_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_route53_resolver_rule.forwarding_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route_table.spoke_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.spoke_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.spoke_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.spoke_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.lambda_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.spoke_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.spoke_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [null_resource.lambda_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | The DNS domain to query (should match Hub account) | `string` | `"example.com"` | no |
| <a name="input_dns_subdomain"></a> [dns\_subdomain](#input\_dns\_subdomain) | The subdomain to query for testing | `string` | `"test"` | no |
| <a name="input_hub_account_id"></a> [hub\_account\_id](#input\_hub\_account\_id) | The AWS Account ID of the Hub account. | `string` | n/a | yes |
| <a name="input_hub_resolver_ips"></a> [hub\_resolver\_ips](#input\_hub\_resolver\_ips) | IP addresses of the Hub inbound resolver endpoints. | <pre>list(object({<br>    ip   = string<br>    port = optional(number, 53)<br>  }))</pre> | n/a | yes |
| <a name="input_hub_vpc_cidr"></a> [hub\_vpc\_cidr](#input\_hub\_vpc\_cidr) | CIDR block of the Hub VPC (for routing and security groups) | `string` | `"10.0.0.0/16"` | no |
| <a name="input_hub_vpc_id"></a> [hub\_vpc\_id](#input\_hub\_vpc\_id) | The ID of the VPC to establish VPC peering with in the Hub account. | `string` | n/a | yes |
| <a name="input_provision_dns_profile"></a> [provision\_dns\_profile](#input\_provision\_dns\_profile) | Whether to provision a DNS profile to share DNS configurations with. | `bool` | `true` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the Spoke VPC (must be /24 or wider) | `string` | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_profile_id"></a> [dns\_profile\_id](#output\_dns\_profile\_id) | ID of the Route 53 profile |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Name of the DNS test Lambda function. |
| <a name="output_peering_connection_id"></a> [peering\_connection\_id](#output\_peering\_connection\_id) | ID of the VPC peering connection. |
| <a name="output_spoke_vpc_id"></a> [spoke\_vpc\_id](#output\_spoke\_vpc\_id) | ID of the Spoke VPC. |
<!-- END_TF_DOCS -->