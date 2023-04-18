
# AWS

variable "knife_domain" {
  type        = string
  description = "knife domain"
}

variable "region" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}

variable "zone_1" {
  type        = string
  description = "aws zone"
  default     = "us-east-2b"
}

variable "vpc_cidr" {
  type        = string
  description = "aws vpc CIDR"
  default     = "192.168.0.0/16"
}

variable "vsw_1_cidr" {
  type        = string
  description = "aws subnet CIDR"
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

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  # default     = "t2.2xlarge"  # T2 family, 32G
  default     = "t2.large"    # T2 family, 8G
}

variable "os_image" {
  type        = string
  description = "Operation System image identification mark"
}

variable "os_type" {
  type        = string
  description = "OS type provided to ansible playbook"
}
variable "os_username" {
  type        = string
  description = "Username initiated in os image"
}
