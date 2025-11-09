# AWS DNS Sharing Solutions

_This is supplementary to my blog post on my website: https://blog.ishkur.uk/tech/guide-to-dns-on-aws. For more context (particularly if you more want to understand the art of the possible than if you just want some code to do the job), have a gander._

This is a collection of Terraform modules and examples for implementing DNS sharing across AWS accounts, VPCs, and hybrid environments using Route 53 Resolver endpoints and profiles.

## Patterns this can support

### Hub-and-Spoke DNS
- Hub account hosts private zones/resolver endpoints
- Spoke accounts/networks forward queries to hub resolvers
- Route 53 profiles enable centralized DNS config management

### Hybrid Cloud Integration
- On-premises networks query AWS-hosted DNS zones via inbound resolver endpoints
- AWS resources resolve on-premises domains via outbound resolver endpoints
- Seamless name resolution across cloud and on-premises

## Repository Structure

```
├── inbound-resolver-endpoints/    # Module: Inbound DNS resolver endpoints
├── outbound-resolver-endpoints/   # Module: Outbound DNS resolver endpoints  
├── route-53-profiles/             # Module: Route 53 profiles for DNS sharing
├── example/                       # Complete working example deployment
│   ├── hub/                       # Hub account infrastructure
│   └── spoke/                     # Spoke account infrastructure
```

## Quick Start

### 1. Deploy the Example

If you deploy the `example` module under this repo, you can see some of the modules woven together to get an idea of how things fit together in a real-world setting.

_Disclaimer: This does cost a pretty significant amount of money. See my blog post for more info on the cost breakdown. Fortunately, it's pretty simple to spin this up, and quickly spin it back down again._

```bash
# Clone the repository
git clone <repository-url>
cd example

# Configure your AWS profiles
cat > terraform.tfvars << EOF
hub_profile   = "my-hub-profile"
spoke_profile = "my-spoke-profile"
EOF

# Deploy the infrastructure
terraform init
terraform apply

# Test DNS resolution
aws lambda invoke --profile my-spoke-profile --function-name dns-test-function response.json
cat response.json
```

### 2. Use Individual Modules

```hcl
# Inbound resolver for receiving DNS queries
module "dns_inbound" {  
  name_prefix = "prod-dns-hub"
  vpc_id      = "vpc-12345678"
  
  resolver_subnets = {
    subnet1 = { subnet_id = "subnet-12345678" }
    subnet2 = { subnet_id = "subnet-87654321" }
  }
  
  allowed_cidr_blocks = ["10.1.0.0/16", "192.168.0.0/16"]
}

# Route 53 profile for centralized DNS management
module "dns_profile" {
  profile_name = "shared-dns-config"
  
  private_hosted_zones = {
    internal = { zone_id = "Z1234567890ABC" }
  }
  
  vpc_associations = {
    spoke1 = { vpc_id = "vpc-spoke1" }
    spoke2 = { vpc_id = "vpc-spoke2" }
  }
}
```

## Use Cases

### Enterprise Hub-and-Spoke
```hcl
# Central DNS hub serving multiple business units
module "enterprise_hub" {
  source = "./inbound-resolver-endpoints"
  
  name_prefix = "enterprise-dns"
  vpc_id      = var.hub_vpc_id
  
  resolver_subnets = var.resolver_subnets
  allowed_cidr_blocks = var.spoke_vpc_cidrs
  
  enable_ram_sharing = true
  ram_principals     = var.business_unit_accounts
}
```

### Hybrid Cloud DNS
```hcl
# Bidirectional DNS between AWS and on-premises
module "hybrid_inbound" {
  source = "./inbound-resolver-endpoints"
  
  resolver_subnets    = var.dmz_subnets
  allowed_cidr_blocks = [var.onprem_cidr]
}

module "hybrid_outbound" {
  source = "./outbound-resolver-endpoints"
  
  resolver_subnets = var.internal_subnets
  resolver_rules = {
    corporate = {
      domain_name = "corp.internal"
      rule_type   = "FORWARD"
      target_ips  = var.onprem_dns_servers
    }
  }
}
```

### Multi-Environment DNS Policies
```hcl
# Different DNS policies for prod/dev environments
module "prod_dns_profile" {
  source = "./route-53-profiles"
  
  profile_name = "production-dns"
  
  dns_firewall_rule_groups = {
    strict_security = {
      firewall_rule_group_id = var.prod_firewall_rules
      priority               = 100
    }
  }
}
```
