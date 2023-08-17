variable "org" {
  description = "The root organization name within Terraform Cloud."
  type        = string
  default     = "frank-cloud"
}

variable "region" {
  type        = string
  description = "aws region"
  default     = "us-east-2"
}
