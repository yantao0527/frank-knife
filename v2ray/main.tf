terraform {
#  required_providers {
#    alicloud = {
#      version = "1.64"
#    }
#  }
}

output "cmd_remote" {
  description = "ssh remote host"
  value       = local.cmd_remote
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}

