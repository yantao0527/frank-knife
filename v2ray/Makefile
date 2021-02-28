check-access:
ifndef ALICLOUD_ACCESS_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_ACCESS_KEY)
endif

check-secret:
ifndef ALICLOUD_SECRET_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_SECRET_KEY)
endif

check-id_rsa:
ifneq ($(shell test -e $(HOME)/.ssh/id_rsa && echo -n yes), yes)
	$(error 请配置 $(HOME)/.ssh/id_rsa)
endif

check-id_rsa-pub:
ifneq ($(shell test -e $(HOME)/.ssh/id_rsa.pub && echo -n yes), yes)
	$(error 请配置 $(HOME)/.ssh/id_rsa.pub)
endif

check: check-id_rsa check-id_rsa-pub check-access check-secret
	@echo 检查环境是否满足
	terraform version
	ansible-playbook --version

init:
	terraform init

validate:
	terraform validate

plan: check-access check-secret
	terraform plan \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

create: check-access check-secret
	@echo 安装v2ray服务器
	terraform apply -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

state-list:
	terraform state list

destroy:
	@echo 销毁v2ray服务器
	terraform destroy -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

remote:
	terraform output -raw cmd_remote > remote.sh
	chmod 0755 remote.sh

playbook:
	terraform output -raw cmd_playbook > playbook.sh
	chmod 0755 playbook.sh

client:
	terraform output -raw v2ray_client
