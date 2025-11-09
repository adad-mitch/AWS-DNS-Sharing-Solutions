locals {  
  # Security group rules based on protocols
  sg_ingress_rules = flatten([
    for protocol in var.protocols : [
      protocol == "Do53" ? [
        {
          from_port   = 53
          to_port     = 53
          protocol    = "tcp"
          description = "DNS over TCP"
        },
        {
          from_port   = 53
          to_port     = 53
          protocol    = "udp"
          description = "DNS over UDP"
        }
      ] : [],
      contains(["DoH", "DoH-FIPS"], protocol) ? [
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "DNS over HTTPS"
        }
      ] : []
    ]
  ])
}
