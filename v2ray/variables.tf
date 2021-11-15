
# Alicloud

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "v2ray"
}

variable "home" {

}

variable "zone_1" {

}

variable "vpc_cidr" {

}

variable "vsw_1_cidr" {

}

# v2ray

variable "v2ray_port" {

}

variable "v2ray_userid" {

}

variable "v2ray_alterId" {

}

# compute instance

variable "compute_status" {
  description = "compute status[ running | stopped ]"
  type        = string
}