variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "hub_profile" {
  description = "The AWS profile used to deploy the Hub account."
  type        = string
}

variable "spoke_profile" {
  description = "The AWS profile used to deploy the Spoke account."
  type        = string
}

variable "hub_vpc_cidr" {
  description = "The CIDR range to use for the Hub VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition = can(cidrhost(var.hub_vpc_cidr, 32)) && tonumber(split("/", var.hub_vpc_cidr)[1]) <= 24
    error_message = "VPC CIDR must be a valid CIDR block with /24 or wider (smaller number) prefix."
  }
}

variable "spoke_vpc_cidr" {
  description = "The CIDR range to use for the Spoke VPC."
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition = can(cidrhost(var.spoke_vpc_cidr, 32)) && tonumber(split("/", var.spoke_vpc_cidr)[1]) <= 24
    error_message = "VPC CIDR must be a valid CIDR block with /24 or wider (smaller number) prefix."
  }
}

variable "phz_domain" {
  description = "The domain to use for the example PHZ that will be associated with the Hub VPC."
  type        = string
  default     = "example.com"
}

variable "phz_record_subdomain" {
  description = "The subdomain to use for the test record in the example PHZ that will be associated with the Spoke VPC."
  type        = string
  default     = "test"
}
