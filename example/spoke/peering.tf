# VPC Peering connection to Hub
resource "aws_vpc_peering_connection" "spoke_to_hub" {
  vpc_id        = aws_vpc.spoke.id
  peer_vpc_id   = var.hub_vpc_id
  peer_region   = data.aws_region.current.region
  peer_owner_id = var.hub_account_id
  auto_accept   = false

  tags = {
    Name = "spoke-to-hub-peering"
  }
}
