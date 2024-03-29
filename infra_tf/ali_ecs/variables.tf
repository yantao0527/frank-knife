
# Alicloud

variable "access_key" {
  type        = string
  description = "阿里云access key"
}

variable "secret_key" {
  type        = string
  description = "阿里云secret key"
}

variable "region" {
  type        = string
  description = "阿里云region"
  default     = "ap-southeast-1"
}

variable "zone_1" {
  type        = string
  description = "阿里云zone"
  default     = "ap-southeast-1b"
}

variable "vpc_cidr" {
  type        = string
  description = "阿里云vpc CIDR"
  default     = "192.168.0.0/16"
}

variable "vsw_1_cidr" {
  type        = string
  description = "阿里云vswitch CIDR"
  default     = "192.168.11.0/24"
}

# compute instance

variable "compute_status" {
  type        = string
  description = "compute status[ Running | Stopped ]"
  default     = "Running"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "infra"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}
