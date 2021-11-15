# IP ADDRESS
resource "alicloud_eip" "eip" {
  name      = "${var.prefix}-eip"
  bandwidth = 10
}

# NETWORK
resource "alicloud_vpc" "vpc" {
  name       = "${var.prefix}-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vsw" {
  name              = "${var.prefix}-vsw"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.vsw_1_cidr
  availability_zone = var.zone_1
}


# COMPUTE ENGINE INSTANCE
resource "alicloud_instance" "compute" {
  image_id             = data.alicloud_images.default.images.0.id
  internet_charge_type = "PayByBandwidth"

  instance_type        = data.alicloud_instance_types.c1g1.instance_types.0.id
  system_disk_category = "cloud_efficiency"
  security_groups      = alicloud_security_group.group.*.id
  instance_name        = "${var.prefix}-vm"
  host_name            = "${var.prefix}-vm"
  vswitch_id           = alicloud_vswitch.vsw.id
  tags = {
    from = "frank-knife"
  }
  status = var.compute_status

  internet_max_bandwidth_out = 0
}

// Import an existing public key to build a alicloud key pair
resource "alicloud_key_pair" "publickey" {
  key_name   = "${var.prefix}-rsa"
  public_key = file("${var.home}/.ssh/id_rsa.pub")
}

resource "alicloud_key_pair_attachment" "attachment" {
  key_name     = alicloud_key_pair.publickey.id
  instance_ids = [alicloud_instance.compute.id]
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
        --extra-vars v2ray_port=${var.v2ray_port} \
        --extra-vars v2ray_userid=${var.v2ray_userid} \
        --extra-vars v2ray_alterId=${var.v2ray_alterId} \
        setup.yml
  EOT  
}
