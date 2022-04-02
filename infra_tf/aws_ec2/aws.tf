resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "knife_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.prefix}-rsa"
  public_key = tls_private_key.global_key.public_key_openssh
}

resource "aws_instance" "compute" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  key_name  = aws_key_pair.key_pair.key_name

  private_ip = "10.0.0.12"
  subnet_id  = aws_subnet.knife_subnet.id

  tags = {
    Name = "ExampleComputeInstance"
  }
}

resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.compute.id
  associate_with_private_ip = "10.0.0.12"
  depends_on                = [aws_internet_gateway.gw]
}

# locals
locals {

  cmd_remote = <<EOT
#      ssh -i ${path.module}/id_rsa root@${aws_eip.eip.public_ip}
      ssh -i ${path.module}/id_rsa trial@${aws_eip.eip.public_ip}
  EOT

  cmd_edit_domain = "jx gitops requirements edit --domain ${aws_eip.eip.public_ip}.xip.io"

  cmd_playbook = <<EOT
      ansible-playbook \
        -i '${aws_eip.eip.public_ip},' \
        -u root \
        --private-key ${path.module}/id_rsa \
        --extra-vars docker_version=${var.docker_version} \
        ../ansible/setup.yml
  EOT  
}
