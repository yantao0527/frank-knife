
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
  # default     = "ami-0a695f0d95cefc163"  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  # default     = "ami-0996d1ddefe09ff57"  # Deep Learning AMI GPU PyTorch 2.0.0 (Ubuntu 20.04) 20230401
  default     = "ami-0ba62214afa52bec7"  # REDHAT 8.4
}

variable "os_type" {
  type        = string
  description = "OS type provided to ansible playbook"
  # default     = "aws_ec2.ubuntu_22.04"
  # default     = "aws_ec2.ubuntu_20.04"
  default     = "aws_ec2.redhat84"
}
variable "os_username" {
  type        = string
  description = "Username initiated in os image"
  # default     = "ubuntu"    # Ubuntu
  default     = "ec2-user"  # Redhat
}
