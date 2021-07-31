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

resource "alicloud_security_group_rule" "accept_docker_registry_proxy_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "3128/3128"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "registry"
}

resource "alicloud_security_group_rule" "accept_octant_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "7777/7777"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "octant"
}

resource "alicloud_security_group_rule" "accept_local_tea_http_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "8080/8080"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "second http"
}

resource "alicloud_security_group_rule" "accept_git_ssh_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "32022/32022"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "git ssh"
}

resource "alicloud_security_group_rule" "accept_git_ssh2_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "32222/32222"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "git ssh2"
}

resource "alicloud_security_group_rule" "accept_k8s_api_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "36443/36443"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "k8s api"
}

resource "alicloud_security_group_rule" "accept_k8s_api2_rule" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "6443/6443"
  priority          = 100
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
  description       = "k8s api2"
}
