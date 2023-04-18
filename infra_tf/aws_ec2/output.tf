
output "node_eip" {
  value = aws_eip.eip.public_ip
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}

output "os_username" {
  description = "username for ssh"
  value       = var.os_username
}
