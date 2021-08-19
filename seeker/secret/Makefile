
repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update

consul:
	helm install consul hashicorp/consul \
	  --namespace vault --create-namespace \
	  --values helm_consul_values.yml

vault-ha:
	helm install vault hashicorp/vault \
	  --namespace vault --create-namespace \
	  --values helm_vault_ha.yml

vault:
	helm install vault hashicorp/vault \
	  --namespace vault --create-namespace \
	  --values helm_vault_values.yml

vault-template:
	helm template vault hashicorp/vault \
	  --namespace vault --create-namespace \
	  --values helm_vault_values.yml \
	  --output-dir output
	  
vault-status:
	kubectl -n vault exec vault-0 -- vault status

vault-init:
	kubectl -n vault exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster_keys.json

cluster-key:
	cat cluster_keys.json | jq -r ".unseal_keys_b64[]"

vault-ha-unseal:
	kubectl -n vault exec vault-0 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")
	kubectl -n vault exec vault-1 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")
	kubectl -n vault exec vault-2 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")

vault-unseal:
	kubectl -n vault exec vault-0 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")

root-token:
	cat cluster_keys.json | jq -r ".root_token"

# Please run: vault login
vault-login:
	kubectl -n vault exec --stdin=true --tty=true vault-0 -- /bin/sh

kv-enable:
	kubectl -n vault exec vault-0 -- vault secrets enable -path=secret kv-v2

kv-put:
	kubectl -n vault exec vault-0 -- vault kv put secret/webapp/config username="frank" password="frank123"

kv-get:
	kubectl -n vault exec vault-0 -- vault kv get secret/webapp/config

# kubernetes authentication
# reference: README.md
vault-kubernetes:
	kubectl -n vault exec --stdin=true --tty=true vault-0 -- /bin/sh

repo-external-secrets:
	helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets/
	helm repo update

external-secrets:
	helm install external-secrets external-secrets/kubernetes-external-secrets \
	  --namespace vault --create-namespace \
	  --values helm_external_secrets_values.yml

apply-es:
	kubectl -n vault apply -f demo_vault_es.yml

status-es:
	kubectl -n vault get es demo-vault-es

delete-es:
	kubectl -n vault delete es demo-vault-es

## vault operator

VAULT_NAMESPACE=vault

vault-pre:
	kubectl create namespace $(VAULT_NAMESPACE)
	kubectl label namespace $(VAULT_NAMESPACE) istio-injection=enabled

vault-operator-repo:
	helm repo add banzaicloud https://kubernetes-charts.banzaicloud.com
	helm repo update

vault-operator:
	helm upgrade --install vault-operator banzaicloud/vault-operator \
	  --namespace $(VAULT_NAMESPACE) --create-namespace \
	  --version 1.13.2

vault-operator-delete:
	helm --namespace $(VAULT_NAMESPACE) delete vault-operator

vault-operator-cr:
	kubectl -n $(VAULT_NAMESPACE) apply -f https://raw.githubusercontent.com/banzaicloud/bank-vaults/master/operator/deploy/rbac.yaml
	kubectl -n $(VAULT_NAMESPACE) apply -f https://raw.githubusercontent.com/banzaicloud/bank-vaults/master/operator/deploy/cr.yaml

vault-instance-repo:
	helm repo add jxgh https://jenkins-x-charts.github.io/repo
	helm repo update

vault-instance:
	helm upgrade --install vault-instance jxgh/vault-instance \
	  --namespace $(VAULT_NAMESPACE) --create-namespace \
	  --values helm_vault_instance_values.yml

vault-instance-ui:
	kubectl -n $(VAULT_NAMESPACE) apply -f ui_vault_instance.yaml

vault-instance-delete:
	helm --namespace $(VAULT_NAMESPACE) delete vault-instance
	
vault-instance-template:
	helm template vault-instance jxgh/vault-instance \
	  --namespace $(VAULT_NAMESPACE) --create-namespace \
	  --values helm_vault_instance_values.yml \
	  --output-dir output

vault-ca:
	kubectl -n $(VAULT_NAMESPACE) get secret vault-tls \
	  -o jsonpath="{.data.ca\.crt}" | base64 --decode > $(PWD)/vault_ca.crt

vault-root-token:
	kubectl -n $(VAULT_NAMESPACE) get secrets vault-unseal-keys \
	  -o jsonpath={.data.vault-root} | base64 --decode && echo