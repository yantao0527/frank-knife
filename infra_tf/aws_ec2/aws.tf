resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.prefix}-gw"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.vsw_1_cidr
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = var.zone_1

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "${var.prefix}-subnet"
  }
}
resource "aws_route_table" "crt" {
    vpc_id = aws_vpc.default.id
    route {
        cidr_block = "0.0.0.0/0" //associated subnet can reach everywhere
        gateway_id = aws_internet_gateway.gw.id //CRT uses this IGW to reach internet
    }

    tags = {
        Name = "${var.prefix}-crt"
    }
}

# route table association for the public subnets
resource "aws_route_table_association" "crta" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = aws_route_table.crt.id
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.prefix}-rsa"
  public_key = tls_private_key.global_key.public_key_openssh
}

resource "aws_instance" "compute" {
  ami           = "ami-0ba62214afa52bec7"  # REDHAT 8.4
  instance_type = "t2.large"

  root_block_device {
    delete_on_termination = true
    volume_size = 40
    volume_type = "gp2"
  }

  key_name = aws_key_pair.key_pair.key_name

  private_ip = "192.168.11.12"
  subnet_id  = aws_subnet.subnet.id

  vpc_security_group_ids = [aws_security_group.group.id]

  tags = {
    Name = "${var.prefix}-instance"
  }
}

resource "aws_eip" "eip" {
  vpc                       = true
  instance                  = aws_instance.compute.id
  associate_with_private_ip = "192.168.11.12"
  depends_on                = [aws_internet_gateway.gw]
}

resource "null_resource" "playbook" {
  depends_on                = [aws_instance.compute, aws_eip.eip]

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for server to be initialized...'"]

    connection {
      type        = "ssh"
      agent       = false
      host        = aws_eip.eip.public_ip
      user        = "ec2-user"
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = local.cmd_playbook
  }
}

# locals
locals {

  cmd_remote = <<EOT
#      ssh -i ${path.module}/id_rsa ec2-user@${aws_eip.eip.public_ip}
      ssh -i ${path.module}/id_rsa trial@${aws_eip.eip.public_ip}
  EOT

  cmd_edit_domain = "jx gitops requirements edit --domain ${aws_eip.eip.public_ip}.xip.io"

  cmd_playbook = <<EOT
      ansible-playbook \
        -i '${aws_eip.eip.public_ip},' \
        -u ec2-user \
        --private-key ${path.module}/id_rsa \
		    --extra-vars infra_type=aws_ec2.redhat84 \
        --extra-vars docker_version=${var.docker_version} \
        ../ansible/setup.yml
  EOT  
}
