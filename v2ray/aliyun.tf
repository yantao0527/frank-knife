provider "alicloud" {
#  version    = "1.64"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# IP ADDRESS
resource "alicloud_eip" "eip" {
  bandwidth  = 10
}

# NETWORK
resource "alicloud_vpc" "vpc" {
  name       = "frank-knife"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vsw" {
  name              = "frank-knife-vsw"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vsw_1_cidr
  availability_zone = var.zone_1
}

# FIREWALL RULE
resource "alicloud_security_group" "group" {
  name        = "frank-knife"
  description = "frank knife security"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "accept_ping_rule" {
  type              = "ingress"
  ip_protocol       = "icmp"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "ping"
}

resource "alicloud_security_group_rule" "accept_ssh_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "ssh"
}

resource "alicloud_security_group_rule" "accept_http_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "http"
}

resource "alicloud_security_group_rule" "accept_https_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "https"
}

resource "alicloud_security_group_rule" "accept_v2ray_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "19327/19327"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "v2ray"
}


# OS IMAGE
data "alicloud_images" "default" {
  name_regex  = "^centos"
  most_recent = true
  owners      = "system"
}

# INSTANCE TYPE
data "alicloud_instance_types" "c1g1" {
  cpu_core_count = 2
  memory_size    = 1
}

# COMPUTE ENGINE INSTANCE
resource "alicloud_instance" "compute" {
  image_id              = data.alicloud_images.default.images.0.id
  internet_charge_type  = "PayByBandwidth"

  instance_type        = data.alicloud_instance_types.c1g1.instance_types.0.id
  system_disk_category = "cloud_efficiency"
  security_groups      = alicloud_security_group.group.*.id
  instance_name        = var.host_name
  host_name            = var.host_name
  vswitch_id           = alicloud_vswitch.vsw.id
  tags                 = {
    from = "frank-knife"
  }

  internet_max_bandwidth_out = 0
}

// Import an existing public key to build a alicloud key pair
resource "alicloud_key_pair" "publickey" {
  key_name   = "frank-knife-rsa"
  public_key = file("${var.home}/.ssh/id_rsa.pub")
}

resource "alicloud_key_pair_attachment" "attachment" {
  key_name     = alicloud_key_pair.publickey.id
  instance_ids = [ alicloud_instance.compute.id ]
}

resource "alicloud_eip_association" "eip_asso" {
  allocation_id = alicloud_eip.eip.id
  instance_id   = alicloud_instance.compute.id

  # We run this to make sure server is initialized before we run the "local exec"
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for server to be initialized...'"]

    connection {
      type        = "ssh"
      agent       = false
      host        = alicloud_eip.eip.ip_address
      user        = "root"
      private_key = file("${var.home}/.ssh/id_rsa")
    }
  }

  provisioner "local-exec" {
    command = local.cmd_playbook
  }
}

# locals
locals {
  
  cmd_remote = "ssh root@${alicloud_eip.eip.ip_address}"

  cmd_playbook = <<EOT
      ansible-playbook \
        -i '${alicloud_eip.eip.ip_address},' \
        -u root \
        --private-key ${var.home}/.ssh/id_rsa \
        setup.yml
  EOT  
}
