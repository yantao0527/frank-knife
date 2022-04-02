
use-rsa:
	-mkdir --mode=0700 $(HOME)/.ssh
	cp id_rsa id_rsa.pub $(HOME)/.ssh
	chmod 0400 $(HOME)/.ssh/id_rsa

new-rsa:
	ssh-keygen -t rsa
	
git-config:
	git config --global user.name frank
	git config --global user.email yantao0527@gmail.com

mirror-aliyun:
	sudo cp /etc/apt/sources.list /etc/apt/sources.list.origin
	sudo sed -i 's/archive\.ubuntu\.com/mirrors\.aliyun\.com/' /etc/apt/sources.list
	sudo apt-get update
	# don't work, why?
	#mkdir $(HOME)/.pip
	#cp pip.conf $(HOME)/.pip/pip.conf

install-utils:
	sudo apt install unzip

install-ansible:
	sudo apt install python3-pip
	sudo pip3 install ansible -i https://mirrors.aliyun.com/pypi/simple/

# k8s-tools:
# 	sudo ansible-playbook -i '127.0.0.1,' --connection=local setup.yml

install-all: install-kind install-k3d \
             install-helm install-helm-diff install-helmfile \
			 install-jx \
			 install-terraform


install-kind: /usr/local/bin/kind
	wget https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
	sudo mv kind-linux-amd64 /usr/local/bin/kind
	sudo chmod 0755 /usr/local/bin/kind

install-k3d: /usr/local/bin/k3d
	wget https://github.com/rancher/k3d/releases/download/v4.4.2/k3d-linux-amd64
	sudo mv k3d-linux-amd64 /usr/local/bin/k3d
	sudo chmod 0755 /usr/local/bin/k3d

install-helm: /usr/local/bin/helm
	wget --output-document=/tmp/helm-v3.5.2-linux-amd64.tar.gz https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz
	tar xvfz /tmp/helm-v3.5.2-linux-amd64.tar.gz -C /tmp
	sudo mv /tmp/linux-amd64/helm /usr/local/bin/helm
	sudo chmod 0755 /usr/local/bin/helm

install-helm-diff:
	helm plugin install https://github.com/databus23/helm-diff

install-helmfile: /usr/local/bin/helmfile
	wget --output-document=/tmp/helmfile_linux_amd64 https://github.com/roboll/helmfile/releases/download/v0.138.7/helmfile_linux_amd64
	sudo mv /tmp/helmfile_linux_amd64 /usr/local/bin/helmfile
	sudo chmod 0755 /usr/local/bin/helmfile

install-jx: /usr/local/bin/jx
	wget --output-document=/tmp/jx-cli-linux-amd64.tar.gz https://github.com/jenkins-x/jx-cli/releases/download/v3.1.353/jx-cli-linux-amd64.tar.gz
	tar xvfz /tmp/jx-cli-linux-amd64.tar.gz -C /tmp
	sudo mv /tmp/jx /usr/local/bin/jx
	sudo chmod 0755 /usr/local/bin/jx

install-terraform: /usr/local/bin/terraform
	wget --output-document=/tmp/terraform_0.14.7_linux_amd64.zip https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
	cd /tmp && unzip terraform_0.14.7_linux_amd64.zip
	sudo mv /tmp/terraform /usr/local/bin/terraform

install-tkn:
	wget --output-document=/tmp/tkn_0.18.0_Linux_x86_64.tar.gz https://github.com/tektoncd/cli/releases/download/v0.18.0/tkn_0.18.0_Linux_x86_64.tar.gz
	sudo tar xvzf /tmp/tkn_0.18.0_Linux_x86_64.tar.gz -C /usr/local/bin/ tkn

install-jq:
	sudo apt-get install jq

install-aws:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
	cd /tmp; unzip awscliv2.zip
	sudo /tmp/aws/install