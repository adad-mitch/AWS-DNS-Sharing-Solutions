# Route table for resolver subnets
resource "aws_route_table" "hub_resolver" {
  vpc_id = aws_vpc.hub.id

  tags = {
    Name = "hub-resolver-rt"
  }
}

resource "aws_route_table_association" "hub_resolver" {
  count = length(aws_subnet.hub_resolver)

  subnet_id      = aws_subnet.hub_resolver[count.index].id
  route_table_id = aws_route_table.hub_resolver.id
}

# Add route to Spoke VPCs in Hub route table
resource "aws_route" "hub_to_spoke" {
  for_each = toset(data.aws_vpc_peering_connections.spokes.ids)

  route_table_id            = aws_route_table.hub_resolver.id
  destination_cidr_block    = data.aws_vpc_peering_connection.spoke[each.key].cidr_block
  vpc_peering_connection_id = each.key
}
