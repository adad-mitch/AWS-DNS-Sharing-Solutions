resource "aws_route_table" "spoke_resolver" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block                = var.hub_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.spoke_to_hub.id
  }

  tags = {
    Name = "spoke-resolver-rt"
  }
}

resource "aws_route_table" "spoke_lambda" {
  vpc_id = aws_vpc.spoke.id

  route {
    cidr_block                = var.hub_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.spoke_to_hub.id
  }

  tags = {
    Name = "spoke-lambda-rt"
  }
}

resource "aws_route_table_association" "spoke_resolver" {
  count = length(aws_subnet.spoke_resolver)

  subnet_id      = aws_subnet.spoke_resolver[count.index].id
  route_table_id = aws_route_table.spoke_resolver.id
}

resource "aws_route_table_association" "spoke_lambda" {
  subnet_id      = aws_subnet.spoke_lambda.id
  route_table_id = aws_route_table.spoke_lambda.id
}
