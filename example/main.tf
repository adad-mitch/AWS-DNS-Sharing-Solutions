module "hub" {
  source = "./hub"
  providers = {
    aws = aws.hub
  }

  vpc_cidr = var.hub_vpc_cidr

  phz_domain           = var.phz_domain
  phz_record_subdomain = var.phz_record_subdomain

  spoke_account_id = data.aws_caller_identity.spoke.account_id
  spoke_vpc_cidrs  = [
    var.spoke_vpc_cidr
  ]
}

module "spoke" {
  source = "./spoke"
  providers = {
    aws = aws.spoke
  }

  vpc_cidr = var.spoke_vpc_cidr

  hub_vpc_id       = module.hub.hub_vpc_id
  hub_account_id   = data.aws_caller_identity.hub.account_id

  # Nest it into an object, since the module also optionally accepts a port
  # (though 53 is the default anyway)
  hub_resolver_ips = [ 
    for inbound_resolver_ip in module.hub.inbound_resolver_ips : {
      ip: inbound_resolver_ip
      port: 53
    }
  ]
}
