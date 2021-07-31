
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

resource "local_file" "cmd_remote" {
  filename        = "${path.module}/remote.sh"
  content         = local.cmd_remote
  file_permission = "0755"
}

resource "local_file" "cmd_playbook" {
  filename        = "${path.module}/playbook.sh"
  content         = local.cmd_playbook
  file_permission = "0755"
}
