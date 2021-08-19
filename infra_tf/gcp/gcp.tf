
# IP ADDRESS
resource "google_compute_address" "ip_address" {
  name = "${var.prefix}-ip-${terraform.workspace}"
}

# FIREWALL RULE
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-${terraform.workspace}"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "3128", "36443", "32022", "32222", "7777", "8080", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-http-${terraform.workspace}"]
}

# COMPUTE ENGINE INSTANCE
resource "google_compute_instance" "instance" {
  name         = "${var.prefix}-vm-${terraform.workspace}"
  machine_type = var.gcp_machine_type

  tags = google_compute_firewall.allow_http.target_tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.os_image.self_link
      size  = 60
    }
  }

  network_interface {
    network = data.google_compute_network.default.name

    access_config {
      nat_ip = google_compute_address.ip_address.address
    }
  }

  service_account {
    scopes = ["storage-ro"]
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

  desired_status = var.vm_instance_status

  # We run this to make sure server is initialized before we run the "local exec"
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for server to be initialized...'"]

    connection {
      type        = "ssh"
      agent       = false
      host        = google_compute_address.ip_address.address
      user        = "trial"
      private_key = file(var.ssh_priv_key_path)
    }
  }

  provisioner "local-exec" {
    command = local.cmd_playbook_1
  }
}

# locals
locals {
  
  cmd_remote = <<EOT
ssh trial@${google_compute_address.ip_address.address}
EOT

  cmd_edit_domain = "jx gitops requirements edit --domain ${google_compute_address.ip_address.address}.xip.io"

  cmd_playbook = <<EOT
      ansible-playbook \
        -i '${google_compute_address.ip_address.address},' \
        -u trial \
        --private-key ${path.module}/id_rsa \
        --extra-vars docker_version=${var.docker_version} \
        ../ansible/setup.yml 
  EOT  
}