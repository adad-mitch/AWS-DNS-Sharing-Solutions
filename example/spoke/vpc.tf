resource "aws_vpc" "spoke" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "spoke-vpc"
  }
}

# Calculate /28 subnets for resolver endpoints
resource "aws_subnet" "spoke_resolver" {
  count = 2

  vpc_id            = aws_vpc.spoke.id
  cidr_block        = cidrsubnet(var.vpc_cidr, (28 - local.vpc_cidr_subnet_suffix), count.index) # Creates /28 subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "spoke-resolver-subnet-${count.index + 1}"
  }
}

# Calculate /28 subnet for Lambda function
resource "aws_subnet" "spoke_lambda" {
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = cidrsubnet(var.vpc_cidr, (28 - local.vpc_cidr_subnet_suffix), 2) # Third /28 subnet
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "spoke-lambda-subnet"
  }
}
