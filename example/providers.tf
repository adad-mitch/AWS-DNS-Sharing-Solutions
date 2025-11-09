terraform {
  # Configure a backend

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias = "hub"

  profile = var.hub_profile
  region  = var.aws_region
}

provider "aws" {
  alias = "spoke"

  profile = var.spoke_profile
  region  = var.aws_region
}
