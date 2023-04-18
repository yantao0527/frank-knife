
output "node_eip" {
  value = alicloud_eip.eip.ip_address
}

output "cmd_remote" {
  description = "ssh remote host"
  value       = local.cmd_remote
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}
