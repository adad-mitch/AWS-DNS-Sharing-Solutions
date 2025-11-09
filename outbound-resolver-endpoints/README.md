# Outbound Resolver Endpoints Module

The flip side of inbound endpoints — these let your AWS resources forward DNS queries to external resolvers (typically on-premises). You create resolver rules that say "queries for this domain should go through this endpoint to these target IPs", and your VPC resolver handles the rest.

Like inbound endpoints, you need two subnets in different AZs, and the module sorts out security groups, and RAM sharing if you need it. You can also create the resolver rules themselves through this module, or manage them separately and just use the endpoint. Your call.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route.outbound_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_endpoint.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.forwarding_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.vpc_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_security_group.resolver_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route_table.subnet_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to make DNS queries through the resolver endpoint. | `set(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | List of security group IDs allowed to make DNS queries through the resolver endpoint. | `set(string)` | `[]` | no |
| <a name="input_enable_ram_sharing"></a> [enable\_ram\_sharing](#input\_enable\_ram\_sharing) | Whether to share the resolver endpoint via AWS Resource Access Manager (RAM). | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Unique string/name to prepend to resources provisioned by this module. | `string` | `"dns-resolver"` | no |
| <a name="input_outbound_routes"></a> [outbound\_routes](#input\_outbound\_routes) | Map of outbound routes to create from resolver endpoint subnets to target DNS servers. Each route can specify different gateways. | <pre>map(object({<br>    destination_cidr_block        = string<br>    gateway_id                    = optional(string)<br>    vpc_peering_connection_id     = optional(string)<br>    transit_gateway_id            = optional(string)<br>    nat_gateway_id                = optional(string)<br>    network_interface_id          = optional(string)<br>    vpc_endpoint_id               = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_protocols"></a> [protocols](#input\_protocols) | List of protocols to support. Valid values are Do53, DoH, and DoH-FIPS. | `set(string)` | <pre>[<br>  "Do53"<br>]</pre> | no |
| <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals) | Whether to allow sharing with external principals (outside your organisation). | `bool` | `false` | no |
| <a name="input_ram_principals"></a> [ram\_principals](#input\_ram\_principals) | List of AWS account IDs or organization IDs to share the resolver endpoint with via RAM (if `enable_ram_sharing` is `true`). | `set(string)` | `[]` | no |
| <a name="input_resolver_rules"></a> [resolver\_rules](#input\_resolver\_rules) | Map of resolver rules to create for forwarding DNS queries to specific domains. | <pre>map(object({<br>    domain_name = string<br>    rule_type   = string # FORWARD or SYSTEM<br>    target_ips = optional(list(object({<br>      ip   = string<br>      port = optional(number, 53)<br>    })), [])<br>  }))</pre> | `{}` | no |
| <a name="input_resolver_subnets"></a> [resolver\_subnets](#input\_resolver\_subnets) | Map of resolver endpoint subnets. Each subnet can optionally specify an IP address, otherwise AWS will assign one automatically. | <pre>map(object({<br>    subnet_id  = string<br>    ip_address = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources provisioned by this module. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to provision the outbound resolver endpoint in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ram_resource_share_arn"></a> [ram\_resource\_share\_arn](#output\_ram\_resource\_share\_arn) | The ARN of the RAM resource share (if enabled). |
| <a name="output_resolver_endpoint_arn"></a> [resolver\_endpoint\_arn](#output\_resolver\_endpoint\_arn) | The ARN of the Route 53 Resolver outbound endpoint. |
| <a name="output_resolver_endpoint_id"></a> [resolver\_endpoint\_id](#output\_resolver\_endpoint\_id) | The ID of the Route 53 Resolver outbound endpoint. |
| <a name="output_resolver_endpoint_ip_addresses"></a> [resolver\_endpoint\_ip\_addresses](#output\_resolver\_endpoint\_ip\_addresses) | List of IP addresses assigned to the resolver endpoint. |
| <a name="output_resolver_rules"></a> [resolver\_rules](#output\_resolver\_rules) | Map of resolver rules created for domain forwarding. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for the resolver endpoint. |
<!-- END_TF_DOCS -->