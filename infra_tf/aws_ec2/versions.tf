terraform {
  required_providers {
    alicloud = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
  required_version = ">= 0.13"
}
