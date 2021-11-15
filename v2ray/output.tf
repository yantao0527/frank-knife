
output "cmd_remote" {
  description = "ssh remote host"
  value       = local.cmd_remote
}

output "cmd_playbook" {
  description = "command ansible-playbook"
  value       = local.cmd_playbook
}

output "v2ray_client" {
  description = "configure for v2ray client"
  value       = <<EOT
V2RAY客户端配置
==============

地址(address)     ${alicloud_eip.eip.ip_address}
端口(port)        ${var.v2ray_port}
用户ID(id)        ${var.v2ray_userid}
额外ID(alterId)   ${var.v2ray_alterId}
别名(remarks)     knife-v2ray
EOT
}

