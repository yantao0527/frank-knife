# FIREWALL RULE
resource "alicloud_security_group" "group" {
  name        = "${var.prefix}-sg"
  description = "frank knife security"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_security_group_rule" "accept_ping_rule" {
  type              = "ingress"
  ip_protocol       = "icmp"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "ping"
}

resource "alicloud_security_group_rule" "accept_ssh_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "ssh"
}

resource "alicloud_security_group_rule" "accept_http_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "80/80"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "http"
}

resource "alicloud_security_group_rule" "accept_https_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "https"
}

resource "alicloud_security_group_rule" "accept_v2ray_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "19325/19335"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "v2ray"
}
