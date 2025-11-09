variable "vpc_cidr" {
  description = "CIDR block for the Hub VPC (must be /24 or wider)"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition = can(cidrhost(var.vpc_cidr, 32)) && tonumber(split("/", var.vpc_cidr)[1]) <= 24
    error_message = "VPC CIDR must be a valid CIDR block with /24 or wider (smaller number) prefix."
  }
}

variable "spoke_account_id" {
  description = "AWS account ID of the Spoke account for peering."
  type        = string
}

variable "spoke_vpc_cidrs" {
  description = "The primary CIDR ranges of any spoke (peered) VPCs."
  type        = set(string)
  default     = []
}

variable "phz_domain" {
  description = "The domain to create the private hosted zone for."
  type        = string
  default     = "example.com"
}

variable "phz_record_subdomain" {
  description = "The subdomain to create the test record for."
  type        = string
  default     = "test"
}
