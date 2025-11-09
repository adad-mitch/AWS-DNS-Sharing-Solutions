locals {  
  # Security group ingress rules based on protocols (for client queries)
  sg_ingress_rules = flatten([
    for protocol in var.protocols : [
      protocol == "Do53" ? [
        {
          from_port   = 53
          to_port     = 53
          protocol    = "tcp"
          description = "DNS over TCP from clients"
        },
        {
          from_port   = 53
          to_port     = 53
          protocol    = "udp"
          description = "DNS over UDP from clients"
        }
      ] : [],
      contains(["DoH", "DoH-FIPS"], protocol) ? [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "DNS over HTTPS from clients"
        }
      ] : []
    ]
  ])

  # Security group egress rules based on protocols (for forwarding to target DNS servers)
  sg_egress_rules = flatten([
    for protocol in var.protocols : [
      protocol == "Do53" ? [
        {
          from_port   = 53
          to_port     = 53
          protocol    = "tcp"
          description = "DNS over TCP to target servers"
        },
        {
          from_port   = 53
          to_port     = 53
          protocol    = "udp"
          description = "DNS over UDP to target servers"
        }
      ] : [],
      contains(["DoH", "DoH-FIPS"], protocol) ? [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "DNS over HTTPS to target servers"
        }
      ] : []
    ]
  ])
}
