locals {
  # Extract AZs from subnets for validation
  subnet_azs = [for subnet in data.aws_subnet.selected : subnet.availability_zone]
  unique_azs = toset(local.subnet_azs)
}

# Checks aren't blocking; they just warn you of things that _could_ be problematic.
# You can technically have all subnets in one AZ, but it's not really a good idea.
check "unique_azs" {
  assert {
    condition     = length(local.unique_azs) > 1
    error_message = "All subnets are in the same availability zone. This reduces resilience."
  }
}
