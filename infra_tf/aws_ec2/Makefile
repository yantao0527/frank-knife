
init-infra:
	cd ../ansible && ansible-playbook init_infra.yml
	if [ ! -d $(HOME)/.kube ]; then mkdir $(HOME)/.kube; fi

check-domain:
ifndef KNIFE_DOMAIN
	$(error Please load or setup env KNIFE_DOMAIN)
endif

check-id_rsa:
ifneq ($(shell test -e $(HOME)/.ssh/id_rsa && echo -n yes), yes)
	$(error Please setup $(HOME)/.ssh/id_rsa)
endif

check-id_rsa-pub:
ifneq ($(shell test -e $(HOME)/.ssh/id_rsa.pub && echo -n yes), yes)
	$(error Please setup $(HOME)/.ssh/id_rsa.pub)
endif

#check: check-id_rsa check-id_rsa-pub check-access check-secret
check: check-domain
	@echo Validate environment
	terraform version
	ansible-playbook --version

init:
	terraform init

validate:
	terraform validate

plan: check-domain
	terraform plan \
	  --var knife_domain=${KNIFE_DOMAIN}

create: check-domain
	@echo Create terraform resource
	terraform apply -auto-approve \
	  --var knife_domain=${KNIFE_DOMAIN}

vm-start: check-access check-secret
	terraform apply -auto-approve \
	  --var knife_domain=${KNIFE_DOMAIN}

vm-stop: check-access check-secret
	terraform apply -auto-approve \
	  --var knife_domain=${KNIFE_DOMAIN} \
	  --var compute_status=Stopped

state-list:
	terraform state list

state-rm-eip:
	terraform state rm AWS_eip_association.eip_asso
	terraform state rm AWS_eip.eip

destroy: check-domain
	@echo Destroy terraform resource
	terraform destroy -auto-approve \
	  --var knife_domain=${KNIFE_DOMAIN} \
	  --var compute_status=Stopped

clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f id_rsa id_rsa.pub
	rm -f playbook.sh remote.sh
	rm -f terraform.tfstate*

fmt:
	terraform fmt

node-eip:
	@terraform output -raw node_eip

copy-git-id:
	ssh -i ./id_rsa trial@$(shell make node-eip) \
	    "git config --global user.name $(shell git config --get user.name); \
	     git config --global user.email $(shell git config --get user.email); \
	     mv .ssh/id_rsa .ssh/id_rsa.old; \
	     cd workspace/frank-knife; git remote set-url origin git@github.com:yantao0527/frank-knife.git; "
	scp -i ./id_rsa $(HOME)/.ssh/id_rsa trial@$(shell make node-eip):.ssh/id_rsa

kubeconfig:
	scp -i ./id_rsa trial@$(shell make node-eip):.kube/config $(HOME)/.kube/knife.conf
	sed -i 's/https\:\/\/0\.0\.0\.0/https\:\/\/nuts\.$(KNIFE_DOMAIN)/' $(HOME)/.kube/knife.conf
	@echo ""
	@echo 'export KUBECONFIG=$$HOME/.kube/knife.conf then kubectl can access k3d'

kubeconfig-dns:
	@echo "Please setup DNS resolve, or add item in /etc/hosts: "
	@echo "$(shell make node-eip)    nuts.$(KNIFE_DOMAIN)"

playbook:
	cat playbook.sh
	./playbook.sh

remote-rm:
	ssh-keygen -f "$(HOME)/.ssh/known_hosts" -R $(shell terraform output node_eip)

remote-root:
	ssh -i ./id_rsa $(shell terraform output -raw os_username)@$(shell terraform output -raw node_eip)

remote:
	ssh -i ./id_rsa trial@$(shell terraform output -raw node_eip)

k8s-create:
	ssh-keygen -f "$(HOME)/.ssh/known_hosts" -R $(shell terraform output node_eip)
	ssh -i ./id_rsa -o StrictHostKeyChecking=no trial@$(shell make node-eip) \
	    "cd workspace/frank-knife/infra_tf/k8s;  make one-click0 "

rancher-password:
	ssh -i ./id_rsa trial@$(shell make node-eip) "docker logs  rancher  2>&1 | grep 'Bootstrap Password:' "


infra: init-infra create k8s-create kubeconfig

