# DNS Resolver Demo Deployment

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 5.0  |

## Providers

| Name                                                               | Version |
| ------------------------------------------------------------------ | ------- |
| <a name="provider_aws.hub"></a> [aws.hub](#provider_aws.hub)       | 6.19.0  |
| <a name="provider_aws.spoke"></a> [aws.spoke](#provider_aws.spoke) | 6.19.0  |

## Modules

| Name                                               | Source  | Version |
| -------------------------------------------------- | ------- | ------- |
| <a name="module_hub"></a> [hub](#module_hub)       | ./hub   | n/a     |
| <a name="module_spoke"></a> [spoke](#module_spoke) | ./spoke | n/a     |

## Resources

| Name                                                                                                                        | Type        |
| --------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_caller_identity.hub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)   | data source |
| [aws_caller_identity.spoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name                                                                                          | Description                                                                                             | Type     | Default         | Required |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | -------- | --------------- | :------: |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region)                               | AWS region to deploy resources into.                                                                    | `string` | `"us-east-1"`   |    no    |
| <a name="input_hub_profile"></a> [hub_profile](#input_hub_profile)                            | The AWS profile used to deploy the Hub account.                                                         | `string` | n/a             |   yes    |
| <a name="input_hub_vpc_cidr"></a> [hub_vpc_cidr](#input_hub_vpc_cidr)                         | The CIDR range to use for the Hub VPC.                                                                  | `string` | `"10.0.0.0/16"` |    no    |
| <a name="input_phz_domain"></a> [phz_domain](#input_phz_domain)                               | The domain to use for the example PHZ that will be associated with the Hub VPC.                         | `string` | `"example.com"` |    no    |
| <a name="input_phz_record_subdomain"></a> [phz_record_subdomain](#input_phz_record_subdomain) | The subdomain to use for the test record in the example PHZ that will be associated with the Spoke VPC. | `string` | `"test"`        |    no    |
| <a name="input_spoke_profile"></a> [spoke_profile](#input_spoke_profile)                      | The AWS profile used to deploy the Spoke account.                                                       | `string` | n/a             |   yes    |
| <a name="input_spoke_vpc_cidr"></a> [spoke_vpc_cidr](#input_spoke_vpc_cidr)                   | The CIDR range to use for the Spoke VPC.                                                                | `string` | `"10.1.0.0/16"` |    no    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
