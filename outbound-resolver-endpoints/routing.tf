# Create outbound routes for each subnet and route combination
resource "aws_route" "outbound_routes" {
  for_each = {
    for pair in setproduct(keys(var.resolver_subnets), keys(var.outbound_routes)) :
    "${pair[0]}-${pair[1]}" => {
      subnet_key   = pair[0]
      subnet_id    = var.resolver_subnets[pair[0]].subnet_id
      route_name   = pair[1]
      route_config = var.outbound_routes[pair[1]]
    }
  }

  route_table_id            = data.aws_route_table.subnet_route_tables[each.value.subnet_key].id
  destination_cidr_block    = each.value.route_config.destination_cidr_block
  
  # Gateway options (exactly one will be non-null due to validation)
  gateway_id                = each.value.route_config.gateway_id
  vpc_peering_connection_id = each.value.route_config.vpc_peering_connection_id
  transit_gateway_id        = each.value.route_config.transit_gateway_id
  nat_gateway_id            = each.value.route_config.nat_gateway_id
  network_interface_id      = each.value.route_config.network_interface_id
  vpc_endpoint_id           = each.value.route_config.vpc_endpoint_id

  depends_on = [aws_route53_resolver_endpoint.outbound]
}
