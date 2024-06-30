
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["309956199498"] # Provided by Red Hat, Inc.

  filter {
    name   = "name"
    values = ["RHEL-8.4*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# data "aws_ami" "centos" {
#   owners      = ["679593333241"]
#   most_recent = true

#   filter {
#       name   = "name"
#       values = ["CentOS Linux 7 x86_64 HVM EBS *"]
#   }

#   filter {
#       name   = "architecture"
#       values = ["x86_64"]
#   }

#   filter {
#       name   = "root-device-type"
#       values = ["ebs"]
#   }
# }

data "aws_route53_zone" "dns" {
  name         = "${var.knife_domain}."
  private_zone = false
}

data "aws_ebs_volume" "llama" {
  most_recent = true

  filter {
    name   = "tag:data"
    values = ["llama"]
  }
}