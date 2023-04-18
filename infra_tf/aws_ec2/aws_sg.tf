resource "aws_security_group" "group" {

    name   = "${var.prefix}-sg"
    vpc_id = aws_vpc.default.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ping"
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production. Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http"
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "https"
    }

    ingress {
        from_port = 3128
        to_port = 3128
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "registry proxy"
    }

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "registry"
    }

    ingress {
        from_port = 7777
        to_port = 7777
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "octant"
    }

    ingress {
        from_port = 7860
        to_port = 7860
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "fastchat"
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "rancher http"
    }

    ingress {
        from_port = 8200
        to_port = 8200
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "vault ui"
    }

    ingress {
        from_port = 8443
        to_port = 8443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "rancher https"
    }

    ingress {
        from_port = 32022
        to_port = 32022
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "git ssh"
    }

    ingress {
        from_port = 32222
        to_port = 32222
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "git ssh2"
    }

    ingress {
        from_port = 36443
        to_port = 36443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "k8s api"
    }

    ingress {
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "k8s api2"
    }

}