resource "aws_route53_zone" "example" {
  name = var.phz_domain

  vpc {
    vpc_id = aws_vpc.hub.id
  }

  tags = {
    Name = var.phz_domain
  }
}

# TXT record for testing
resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "${var.phz_record_subdomain}.${var.phz_domain}"
  type    = "TXT"
  ttl     = 300
  records = ["Hello from Hub DNS!"]
}

# Inbound resolver endpoints using our module
module "inbound_resolver" {
  source = "../../inbound-resolver-endpoints"

  name_prefix = "hub-dns"
  vpc_id      = aws_vpc.hub.id

  resolver_subnets = {
    subnet1 = {
      subnet_id = aws_subnet.hub_resolver[0].id
    }
    subnet2 = {
      subnet_id = aws_subnet.hub_resolver[1].id
    }
  }

  allowed_cidr_blocks = [
    for pcx in toset(data.aws_vpc_peering_connections.spokes.ids) : data.aws_vpc_peering_connection.spoke[pcx].cidr_block
  ]

  tags = {
    Environment = "demo"
    Purpose     = "dns-hub"
  }
}
