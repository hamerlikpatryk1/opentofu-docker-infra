terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "registry.opentofu.org/hashicorp/aws"
      version = "~> 5.47"
    }
  }
}
