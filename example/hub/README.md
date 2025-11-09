# Hub Account DNS Infrastructure

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_inbound_resolver"></a> [inbound\_resolver](#module\_inbound\_resolver) | ../../inbound-resolver-endpoints | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route.hub_to_spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_record.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.hub_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.hub_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.hub_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_peering_connection_accepter.spoke_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_vpc_peering_connection.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |
| [aws_vpc_peering_connections.spokes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connections) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_phz_domain"></a> [phz\_domain](#input\_phz\_domain) | The domain to create the private hosted zone for. | `string` | `"example.com"` | no |
| <a name="input_phz_record_subdomain"></a> [phz\_record\_subdomain](#input\_phz\_record\_subdomain) | The subdomain to create the test record for. | `string` | `"test"` | no |
| <a name="input_spoke_account_id"></a> [spoke\_account\_id](#input\_spoke\_account\_id) | AWS account ID of the Spoke account for peering. | `string` | n/a | yes |
| <a name="input_spoke_vpc_cidrs"></a> [spoke\_vpc\_cidrs](#input\_spoke\_vpc\_cidrs) | The primary CIDR ranges of any spoke (peered) VPCs. | `set(string)` | `[]` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the Hub VPC (must be /24 or wider) | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | ID of the example private hosted zone. |
| <a name="output_hub_vpc_id"></a> [hub\_vpc\_id](#output\_hub\_vpc\_id) | ID of the Hub VPC. |
| <a name="output_inbound_resolver_ips"></a> [inbound\_resolver\_ips](#output\_inbound\_resolver\_ips) | IP addresses of the inbound resolver endpoints. |
<!-- END_TF_DOCS -->