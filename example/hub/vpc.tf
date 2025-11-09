resource "aws_vpc" "hub" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "hub-vpc"
  }
}

# Calculate /28 subnets for resolver endpoints
resource "aws_subnet" "hub_resolver" {
  count = 2

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(var.vpc_cidr, (28 - local.vpc_cidr_subnet_suffix), count.index) # Creates /28 subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "hub-resolver-subnet-${count.index + 1}"
  }
}
