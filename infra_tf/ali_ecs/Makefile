
init-infra:
	cd ../ansible && ansible-playbook init_infra.yml

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
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

create: check-access check-secret
	@echo 创建terraform资源
	terraform apply -auto-approve \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

vm-start: check-access check-secret
	terraform apply -auto-approve \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY)

vm-stop: check-access check-secret
	terraform apply -auto-approve \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Stopped

state-list:
	terraform state list

destroy:
	@echo 销毁terraform资源
	terraform destroy -auto-approve \
	  --var access_key=$(ALICLOUD_ACCESS_KEY) \
	  --var secret_key=$(ALICLOUD_SECRET_KEY) \
	  --var compute_status=Stopped

clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f id_rsa id_rsa.pub
	rm -f playbook.sh remote.sh
	rm -f terraform.tfstate*

fmt:
	terraform fmt

copy-git-id:
	ssh -i ./id_rsa trial@47.241.96.72 \
	    "git config --global user.name $(shell git config --get user.name); \
	     git config --global user.email $(shell git config --get user.email)"
	ssh -i ./id_rsa trial@47.241.96.72 \
	    "cd workspace/frank-knife; git remote set-url origin git@github.com:yantao0527/frank-knife.git"
	scp -i ./id_rsa $(HOME)/.ssh/id_rsa trial@47.241.96.72:.ssh/id_rsa