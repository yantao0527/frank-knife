
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
	  --namespace vault \
	  --values helm_external_secrets_values.yml

apply-es:
	kubectl -n vault apply -f demo_vault_es.yml

status-es:
	kubectl -n vault get es demo-vault-es

delete-es:
	kubectl -n vault delete es demo-vault-es
