resource "aws_vpc_peering_connection_accepter" "spoke_peering" {
  for_each = toset(data.aws_vpc_peering_connections.spokes.ids)

  vpc_peering_connection_id = each.key
  auto_accept               = true
}
