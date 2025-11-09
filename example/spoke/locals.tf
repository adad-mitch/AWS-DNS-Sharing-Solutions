locals {
  vpc_cidr_subnet_suffix = tonumber(split("/", var.vpc_cidr)[1])
}
