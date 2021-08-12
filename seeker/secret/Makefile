
repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo update

consul:
	helm install consul hashicorp/consul --values helm_consul_values.yml

vault:
	helm install vault hashicorp/vault --values helm_vault_values.yml

vault-status:
	kubectl exec vault-0 -- vault status

vault-init:
	kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster_keys.json

cluster-key:
	cat cluster_keys.json | jq -r ".unseal_keys_b64[]"

vault-unseal:
	kubectl exec vault-0 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")
	kubectl exec vault-1 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")
	kubectl exec vault-2 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")

root-token:
	cat cluster_keys.json | jq -r ".root_token"

# Please run: vault login
vault-login:
	kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh

secrets-enable:
	kubectl exec vault-0 -- vault secrets enable -path=secret kv-v2

kv-put:
	kubectl exec vault-0 -- vault kv put secret/webapp/config username="frank" password="frank123"

kv-get:
	kubectl exec vault-0 -- vault kv get secret/webapp/config

# kubernetes authentication
# reference: README.md
vault-kubernetes:
	kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh