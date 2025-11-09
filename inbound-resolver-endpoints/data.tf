data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnet" "selected" {
  for_each = var.resolver_subnets
  id       = each.value.subnet_id
}

# Route table data for return route management
data "aws_route_table" "subnet_route_tables" {
  for_each  = length(var.return_routes) > 0 ? var.resolver_subnets : {}
  subnet_id = each.value.subnet_id
}
