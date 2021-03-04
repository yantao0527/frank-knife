
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

variable "home" {

}

variable "zone_1" {

}

variable "host_name" {

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
  type  = string
}