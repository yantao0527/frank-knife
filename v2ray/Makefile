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

fmt:
	terraform fmt

plan: check-access check-secret
	terraform plan \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Running

create: check-access check-secret
	@echo 安装v2ray服务器
	terraform apply -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Running

vm-start: check-access check-secret
	terraform apply -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Running

vm-stop: check-access check-secret
	terraform apply -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Stopped

state-list:
	terraform state list

destroy:
	@echo 销毁v2ray服务器
	terraform destroy -auto-approve \
	  --var home=$(HOME) \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Stopped

TERRAFORM_OUTPUT=terraform output

remote:
	$(TERRAFORM_OUTPUT) cmd_remote > remote.sh
	chmod 0755 remote.sh

playbook:
	$(TERRAFORM_OUTPUT) cmd_playbook > playbook.sh
	chmod 0755 playbook.sh

client:
	$(TERRAFORM_OUTPUT) v2ray_client

clean:
	rm -rf .terraform
	rm -f playbook.sh remote.sh
	rm -f terraform.tfstate*

## For terraform version v0.14
TERRAFORM_OUTPUT2=terraform output -raw
remote2:
	$(TERRAFORM_OUTPUT2) cmd_remote > remote.sh
	chmod 0755 remote.sh

playbook2:
	$(TERRAFORM_OUTPUT2) cmd_playbook > playbook.sh
	chmod 0755 playbook.sh

