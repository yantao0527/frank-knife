
output "node_eip" {
  value = aws_eip.eip.public_ip
}

output "cmd_remote" {
  description = "ssh remote host"
  value       = local.cmd_remote
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}
