variable "profile_name" {
  description = "Name of the Route 53 Profile."
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.profile_name))
    error_message = "Profile name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
  
  validation {
    condition     = length(var.profile_name) >= 1 && length(var.profile_name) <= 64
    error_message = "Profile name must be between 1 and 64 characters long."
  }
}

variable "vpc_associations" {
  description = "Map of VPCs to associate with the Route 53 Profile. Each VPC must be in the same region as the profile."
  type = map(object({
    vpc_id = string
  }))
  default = {}
}

variable "private_hosted_zones" {
  description = "Map of Private Hosted Zones to associate with the Route 53 Profile. Provide either zone_id (for same account) or resource_arn (for cross-account)."
  type = map(object({
    zone_id      = optional(string)
    resource_arn = optional(string)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for key, zone in var.private_hosted_zones : 
      (zone.zone_id != null && zone.resource_arn == null) || (zone.zone_id == null && zone.resource_arn != null)
    ])
    error_message = "Each private hosted zone must specify either zone_id OR resource_arn, but not both."
  }
  
  validation {
    condition = alltrue([
      for key, zone in var.private_hosted_zones : 
      zone.zone_id == null || can(regex("^Z[A-Z0-9]+$", zone.zone_id))
    ])
    error_message = "All zone IDs must be valid Route 53 hosted zone IDs (format: Z followed by alphanumeric characters)."
  }
  
  validation {
    condition = alltrue([
      for key, zone in var.private_hosted_zones : 
      zone.resource_arn == null || can(regex("^arn:aws:route53:::hostedzone/Z[A-Z0-9]+$", zone.resource_arn))
    ])
    error_message = "All resource ARNs must be valid Route 53 hosted zone ARNs (format: arn:aws:route53:::hostedzone/Z...)."
  }
}

variable "resolver_rules" {
  description = "Map of resolver rules to associate with the Route 53 Profile. Provide either rule_id (for same account) or resource_arn (for cross-account)."
  type = map(object({
    rule_id      = optional(string)
    resource_arn = optional(string)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for key, rule in var.resolver_rules : 
      (rule.rule_id != null && rule.resource_arn == null) || (rule.rule_id == null && rule.resource_arn != null)
    ])
    error_message = "Each resolver rule must specify either rule_id OR resource_arn, but not both."
  }
  
  validation {
    condition = alltrue([
      for key, rule in var.resolver_rules : 
      rule.rule_id == null || can(regex("^rslvr-rr-[a-z0-9]+$", rule.rule_id))
    ])
    error_message = "All rule IDs must be valid resolver rule IDs (format: rslvr-rr- followed by alphanumeric characters)."
  }
  
  validation {
    condition = alltrue([
      for key, rule in var.resolver_rules : 
      rule.resource_arn == null || can(regex("^arn:aws:route53resolver:[a-z0-9-]+:[0-9]{12}:resolver-rule/rslvr-rr-[a-z0-9]+$", rule.resource_arn))
    ])
    error_message = "All resource ARNs must be valid resolver rule ARNs (format: arn:aws:route53resolver:region:account:resolver-rule/rslvr-rr-...)."
  }
}

variable "vpc_endpoints" {
  description = "Map of VPC endpoints to associate with the Route 53 Profile. Provide either vpc_endpoint_id (for same account) or resource_arn (for cross-account)."
  type = map(object({
    vpc_endpoint_id = optional(string)
    resource_arn    = optional(string)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for key, endpoint in var.vpc_endpoints : 
      (endpoint.vpc_endpoint_id != null && endpoint.resource_arn == null) || (endpoint.vpc_endpoint_id == null && endpoint.resource_arn != null)
    ])
    error_message = "Each VPC endpoint must specify either vpc_endpoint_id OR resource_arn, but not both."
  }
  
  validation {
    condition = alltrue([
      for key, endpoint in var.vpc_endpoints : 
      endpoint.vpc_endpoint_id == null || can(regex("^vpce-[a-z0-9]+$", endpoint.vpc_endpoint_id))
    ])
    error_message = "All VPC endpoint IDs must be valid (format: vpce- followed by alphanumeric characters)."
  }
  
  validation {
    condition = alltrue([
      for key, endpoint in var.vpc_endpoints : 
      endpoint.resource_arn == null || can(regex("^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:vpc-endpoint/vpce-[a-z0-9]+$", endpoint.resource_arn))
    ])
    error_message = "All resource ARNs must be valid VPC endpoint ARNs (format: arn:aws:ec2:region:account:vpc-endpoint/vpce-...)."
  }
}

variable "dns_firewall_rule_groups" {
  description = "Map of DNS firewall rule groups to associate with the Route 53 Profile. Provide either firewall_rule_group_id (for same account) or resource_arn (for cross-account)."
  type = map(object({
    firewall_rule_group_id = optional(string)
    resource_arn           = optional(string)
    priority               = number
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for key, group in var.dns_firewall_rule_groups : 
      (group.firewall_rule_group_id != null && group.resource_arn == null) || (group.firewall_rule_group_id == null && group.resource_arn != null)
    ])
    error_message = "Each DNS firewall rule group must specify either firewall_rule_group_id OR resource_arn, but not both."
  }
  
  validation {
    condition = alltrue([
      for key, group in var.dns_firewall_rule_groups : 
      group.firewall_rule_group_id == null || can(regex("^rslvr-frg-[a-z0-9]+$", group.firewall_rule_group_id))
    ])
    error_message = "All firewall rule group IDs must be valid (format: rslvr-frg- followed by alphanumeric characters)."
  }
  
  validation {
    condition = alltrue([
      for key, group in var.dns_firewall_rule_groups : 
      group.resource_arn == null || can(regex("^arn:aws:route53resolver:[a-z0-9-]+:[0-9]{12}:firewall-rule-group/rslvr-frg-[a-z0-9]+$", group.resource_arn))
    ])
    error_message = "All resource ARNs must be valid DNS firewall rule group ARNs (format: arn:aws:route53resolver:region:account:firewall-rule-group/rslvr-frg-...)."
  }
  
  validation {
    condition = alltrue([
      for key, group in var.dns_firewall_rule_groups : 
      group.priority >= 100 && group.priority <= 9000
    ])
    error_message = "Firewall rule group priorities must be between 100 and 9000."
  }
}

variable "enable_ram_sharing" {
  description = "Whether to share the Route 53 Profile via AWS Resource Access Manager (RAM)."
  type        = bool
  default     = false
}

variable "ram_principals" {
  description = "List of AWS account IDs or organization IDs to share the Route 53 Profile with via RAM (if `enable_ram_sharing` is `true`)."
  type        = set(string)
  default     = []
  
  validation {
    condition = alltrue([
      for principal in var.ram_principals : 
      can(regex("^[0-9]{12}$", principal)) || can(regex("^o-[a-z0-9]{10,32}$", principal))
    ])
    error_message = "RAM principals must be valid 12-digit AWS account IDs or organization IDs (format: o- followed by alphanumeric characters)."
  }
}

variable "ram_allow_external_principals" {
  description = "Whether to allow sharing with external principals (outside your organisation)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to resources provisioned by this module."
  type        = map(string)
  default     = {}
}