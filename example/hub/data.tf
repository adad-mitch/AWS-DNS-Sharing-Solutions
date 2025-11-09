data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc_peering_connections" "spokes" {
  # This isn't flawlessly robust, but the alternative would be to use VPC IDs.
  # That would work robustly, but it requires a targeted apply, which isn't great.
  # Since peering connections must have mutually-exclusive CIDR ranges to function
  # properly anyway (e.g., for return route disambiguation), checking the CIDR range
  # and a safeguard of the account ID is realistically going to be sufficient.
  filter {
    name   = "requester-vpc-info.cidr-block"
    values = var.spoke_vpc_cidrs
  }

  filter {
    name   = "requester-vpc-info.owner-id"
    values = [var.spoke_account_id]
  }
}

data "aws_vpc_peering_connection" "spoke" {
  for_each = toset(data.aws_vpc_peering_connections.spokes.ids)

  id = each.key
}
