
output "node_eip" {
  value = google_compute_address.ip_address.address
}

output "cmd_remote" {
  description = "ssh remote host"
  value       = local.cmd_remote
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}
