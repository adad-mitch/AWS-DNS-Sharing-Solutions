variable "vpc_cidr" {
  description = "CIDR block for the Spoke VPC (must be /24 or wider)"
  type        = string
  default     = "10.1.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 32)) && tonumber(split("/", var.vpc_cidr)[1]) <= 24
    error_message = "VPC CIDR must be a valid CIDR block with /24 or wider (smaller number) prefix."
  }
}

variable "hub_vpc_id" {
  description = "The ID of the VPC to establish VPC peering with in the Hub account."
  type        = string
}

variable "hub_account_id" {
  description = "The AWS Account ID of the Hub account."
  type        = string
}

variable "hub_resolver_ips" {
  description = "IP addresses of the Hub inbound resolver endpoints."
  type = list(object({
    ip   = string
    port = optional(number, 53)
  }))
}

variable "dns_domain" {
  description = "The DNS domain to query (should match Hub account)"
  type        = string
  default     = "example.com"
}

variable "dns_subdomain" {
  description = "The subdomain to query for testing"
  type        = string
  default     = "test"
}

variable "hub_vpc_cidr" {
  description = "CIDR block of the Hub VPC (for routing and security groups)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "provision_dns_profile" {
  description = "Whether to provision a DNS profile to share DNS configurations with."
  type        = bool
  default     = true
}
