variable "name_prefix" {
  description = "Unique string/name to prepend to resources provisioned by this module."
  type        = string
  default     = "dns-resolver"
}

variable "vpc_id" {
  description = "The ID of the VPC to provision the outbound resolver endpoint in."
  type        = string
}

variable "resolver_subnets" {
  description = "Map of resolver endpoint subnets. Each subnet can optionally specify an IP address, otherwise AWS will assign one automatically."
  type = map(object({
    subnet_id  = string
    ip_address = optional(string)
  }))
  
  validation {
    condition     = length(var.resolver_subnets) >= 2
    error_message = "At least 2 resolver subnets must be provided for high availability."
  }
}

variable "protocols" {
  description = "List of protocols to support. Valid values are Do53, DoH, and DoH-FIPS."
  type        = set(string)
  default     = ["Do53"]
  validation {
    condition = alltrue([
      for protocol in var.protocols : contains(["Do53", "DoH", "DoH-FIPS"], protocol)
    ])
    error_message = "Protocols must be one of: Do53, DoH, DoH-FIPS."
  }
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to make DNS queries through the resolver endpoint."
  type        = set(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "List of security group IDs allowed to make DNS queries through the resolver endpoint."
  type        = set(string)
  default     = []
}

variable "resolver_rules" {
  description = "Map of resolver rules to create for forwarding DNS queries to specific domains."
  type = map(object({
    domain_name = string
    rule_type   = string # FORWARD or SYSTEM
    target_ips = optional(list(object({
      ip   = string
      port = optional(number, 53)
    })), [])
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for rule_name, rule in var.resolver_rules : 
      contains(["FORWARD", "SYSTEM"], rule.rule_type)
    ])
    error_message = "Rule type must be either 'FORWARD' or 'SYSTEM'."
  }
  
  validation {
    condition = alltrue([
      for rule_name, rule in var.resolver_rules : 
      rule.rule_type != "FORWARD" || length(rule.target_ips) > 0
    ])
    error_message = "FORWARD rules must specify at least one target IP address."
  }
}

variable "enable_ram_sharing" {
  description = "Whether to share the resolver endpoint via AWS Resource Access Manager (RAM)."
  type        = bool
  default     = false
}

variable "ram_principals" {
  description = "List of AWS account IDs or organization IDs to share the resolver endpoint with via RAM (if `enable_ram_sharing` is `true`)."
  type        = set(string)
  default     = []
}

variable "ram_allow_external_principals" {
  description = "Whether to allow sharing with external principals (outside your organisation)."
  type        = bool
  default     = false
}

variable "outbound_routes" {
  description = "Map of outbound routes to create from resolver endpoint subnets to target DNS servers. Each route can specify different gateways."
  type = map(object({
    destination_cidr_block        = string
    gateway_id                    = optional(string)
    vpc_peering_connection_id     = optional(string)
    transit_gateway_id            = optional(string)
    nat_gateway_id                = optional(string)
    network_interface_id          = optional(string)
    vpc_endpoint_id               = optional(string)
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for route_name, route in var.outbound_routes : (
        (route.gateway_id != null ? 1 : 0) +
        (route.vpc_peering_connection_id != null ? 1 : 0) +
        (route.transit_gateway_id != null ? 1 : 0) +
        (route.nat_gateway_id != null ? 1 : 0) +
        (route.network_interface_id != null ? 1 : 0) +
        (route.vpc_endpoint_id != null ? 1 : 0)
      ) == 1
    ])
    error_message = <<-EOT
      Each outbound route must specify exactly one target, from:
      gateway_id, vpc_peering_connection_id, transit_gateway_id, nat_gateway_id, network_interface_id, or vpc_endpoint_id.
    EOT
  }
}

variable "tags" {
  description = "A map of tags to assign to resources provisioned by this module."
  type        = map(string)
  default     = {}
}
