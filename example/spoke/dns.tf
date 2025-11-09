# Forward the DNS query on to our hub
resource "aws_route53_resolver_rule" "forwarding_rule" {
  domain_name          = "${var.dns_subdomain}.${var.dns_domain}"
  name                 = "spoke-forwarding-rule"
  rule_type            = "FORWARD"

  # Target IP addresses for FORWARD rules
  dynamic "target_ip" {
    for_each = var.hub_resolver_ips
    content {
      ip   = target_ip.value.ip
      port = target_ip.value.port
    }
  }
}

# Route 53 Profile using our module
module "dns_profile" {
  count  = var.provision_dns_profile ? 1 : 0
  source = "../../route-53-profiles"

  profile_name = "spoke-dns-profile"

  resolver_rules = {
    domain_rule = {
      rule_id = aws_route53_resolver_rule.forwarding_rule.id
    }
  }

  vpc_associations = {
    spoke = {
      vpc_id = aws_vpc.spoke.id
    }
  }
}
