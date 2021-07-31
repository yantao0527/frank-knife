# IP ADDRESS
resource "alicloud_eip" "eip" {
  bandwidth = 10
}

# NETWORK
resource "alicloud_vpc" "vpc" {
  vpc_name   = "${var.prefix}-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vsw" {
  vswitch_name = "${var.prefix}-vsw"
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vsw_1_cidr
  zone_id      = var.zone_1
}

# COMPUTE ENGINE INSTANCE
resource "alicloud_instance" "compute" {
  image_id             = data.alicloud_images.default.images.0.id
  internet_charge_type = "PayByBandwidth"

  instance_type        = data.alicloud_instance_types.c1g1.instance_types.0.id
  system_disk_category = "cloud_efficiency"
  security_groups      = alicloud_security_group.group.*.id
  instance_name        = var.host_name
  host_name            = var.host_name
  vswitch_id           = alicloud_vswitch.vsw.id
  tags = {
    from = "frank-knife"
  }
  status = var.compute_status

  internet_max_bandwidth_out = 0
}

# Use an existing public key to build a alicloud key pair
resource "alicloud_key_pair" "publickey" {
  key_pair_name = "frank-knife-rsa"
  public_key    = tls_private_key.global_key.public_key_openssh
}

resource "alicloud_key_pair_attachment" "attachment" {
  key_pair_name = alicloud_key_pair.publickey.id
  instance_ids  = [alicloud_instance.compute.id]
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
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  provisioner "local-exec" {
    command = local.cmd_playbook
  }
}

# locals
locals {

  cmd_remote = "ssh root@${alicloud_eip.eip.ip_address}"

  cmd_edit_domain = "jx gitops requirements edit --domain ${alicloud_eip.eip.ip_address}.xip.io"

  cmd_playbook = <<EOT
      ansible-playbook \
        -i '${alicloud_eip.eip.ip_address},' \
        -u root \
        --private-key ${path.module}/id_rsa \
        --extra-vars docker_version=${var.docker_version} \
        ../ansible/setup.yml
  EOT  
}
