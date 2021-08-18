SPECIAL_TARGET=nuts
#SPECIAL_TARGET=laptop
DOMAIN=nuts.yantao0527.me

include Makefile.mk

## argocd

argocd-pre:
	kubectl create namespace argocd
	kubectl label namespace argocd istio-injection=enabled --overwrite

argocd-tls:
	kubectl -n istio-system create secret tls argocd-tls \
	  --key certs/argocd.$(DOMAIN)/privkey.pem \
	  --cert certs/argocd.$(DOMAIN)/fullchain.pem

argocd-gateway:
	kubectl -n argocd apply -f base/argocd/argocd_gateway.yaml

argocd-base:
	kubectl -n argocd apply -k base/argocd

argocd: argocd-pre argocd-base argocd-tls

argocd-post: argocd-password argocd-login argocd-update-password argocd-gateway

argocd-kustomize:
	kubectl kustomize base/argocd > special/common/argocd/argocd.yaml

argocd-special:
	kubectl -n argocd apply -f special/common/argocd/argocd.yaml
	
argocd-status:
	kubectl -n argocd get pod

argocd-delete:
	kubectl delete namespace argocd
	kubectl -n istio-system delete secret argocd-tls
	
#--- argocd-apps ---

argocd-apps-base: website-pre website-tls gitea-pre argocd-apps-base-

argocd-apps-base-:
	kubectl -n argocd apply -k base/apps
	
argocd-apps-kustomize:
	kubectl kustomize overlays/${SPECIAL_TARGET}/apps > special/${SPECIAL_TARGET}/apps/apps.yaml

argocd-apps-special:
	kubectl -n argocd apply -f special/${SPECIAL_TARGET}/apps/apps.yaml
	
#== website ===

website-pre:
	kubectl create namespace website
	kubectl label namespace website istio-injection=enabled

website-tls:
	kubectl -n istio-system create secret tls website-tls \
	  --key certs/$(DOMAIN)/privkey.pem \
	  --cert certs/$(DOMAIN)/fullchain.pem

website-base:
	kubectl -n website apply -k base/website

website: website-pre website-base website-tls

website-delete:
	kubectl delete namespace website

website-kustomize:
	kubectl kustomize overlays/${SPECIAL_TARGET}/website > special/${SPECIAL_TARGET}/website/website.yaml

website-special:
	kubectl -n website apply -f special/${SPECIAL_TARGET}/website/website.yaml

website-argocd:
	argocd app create website \
	  --port-forward-namespace argocd \
	  --repo git@e.coding.net:yantao0527/nuts/studio.git \
	  --path special/${SPECIAL_TARGET}/website \
	  --dest-server https://kubernetes.default.svc \
	  --dest-namespace website

## vault

vault-pre:
	kubectl create namespace jx-vault

vault-base:
	helmfile --file base/vault/helmfile_vault.yaml apply

vault-build:
	rm -rf special/common/vault
	mkdir special/common/vault
	helmfile --file base/vault/helmfile_vault.yaml template --include-crds --output-dir-template $(PWD)/special/common/vault

vault-delete:
	kubectl delete namespace jx-vault

vault-status:
	kubectl -n jx-vault exec vault-0 -- vault status

vault-init:
	kubectl -n jx-vault exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster_keys.json

cluster-key:
	cat cluster_keys.json | jq -r ".unseal_keys_b64[]"

vault-unseal:
	kubectl -n jx-vault exec vault-0 -- vault operator unseal $(shell cat cluster_keys.json | jq -r ".unseal_keys_b64[]")

root-token:
	cat cluster_keys.json | jq -r ".root_token"

vault-argocd: vault-pre
	kubectl apply -f base/vault/app_vault.yaml

# Please run: vault login
vault-login:
	kubectl -n jx-vault exec --stdin=true --tty=true vault-0 -- /bin/sh

kv-enable:
	kubectl -n jx-vault exec vault-0 -- vault secrets enable -path=secret kv-v2

kv-put:
	kubectl -n jx-vault exec vault-0 -- vault kv put secret/webapp/config username="frank" password="frank123"

kv-get:
	kubectl -n jx-vault exec vault-0 -- vault kv get secret/webapp/config

# kubernetes authentication
# reference: README.md
vault-kubernetes:
	kubectl -n jx-vault exec --stdin=true --tty=true vault-0 -- /bin/sh

	
## gitea

gitea-pre:
	kubectl create namespace git
	kubectl label namespace git istio-injection=enabled

gitea-base:
	helmfile --file base/gitea/helmfile_gitea.yaml apply

gitea-build:
	rm -rf special/common/gitea
	mkdir special/common/gitea
	helmfile --file base/gitea/helmfile_gitea.yaml template --include-crds --output-dir-template $(PWD)/special/common

gitea-special:
	kubectl -n git apply -f special/common/gitea

gitea-tls:
	kubectl create secret tls tls-yantao0527 \
	  --cert=fullchain.pem \
	  --key=privkey.pem \
	  -n istio-system

gitea-gateway:
	kubectl apply -f gitea_gateway.yaml -n git
	kubectl apply -f gitea_gateway_tcp.yaml -n git
	
gitea-gateway-tcp:
	kubectl apply -f gitea_gateway_tcp.yaml -n git
	
gitea-delete:
	kubectl delete namespace git


## leasing

leasing-pre:
	kubectl create namespace leasing
	kubectl label namespace leasing istio-injection=enabled --overwrite

leasing-postgres:
	kubectl -n leasing apply -f base/leasing/11_postgres.yaml

leasing-postgres-watch:
	kubectl -n leasing rollout status deployment/leasing-postgres-v10.7 --watch

lleasing-redis:
	kubectl -n leasing apply -f base/leasing/21_redis.yaml

leasing-mongo:
	kubectl -n leasing apply -f base/leasing/22_mongo.yaml

leasing-mongo-watch:
	kubectl -n leasing rollout status deployment/leasing-mongodb-v3.6.17 --watch

leasing-server:
	kubectl -n leasing apply -f base/leasing/31_server.yaml

leasing-admin:
	kubectl -n leasing apply -f base/leasing/32_admin.yaml

leasing-worker:
	kubectl -n leasing apply -f base/leasing/33_worker.yaml

leasing-dashboard:
	kubectl -n leasing apply -f base/leasing/34_dashboard.yaml

leasing-gateway:
	kubectl -n leasing apply -f base/leasing/99_gateway.yaml

leasing: leasing-pre \
         leasing-postgres \
         leasing-redis leasing-mongo \
		 leasing-gateway

leasing-init:
	${MAKE} mongo-init
	${MAKE} pg-init

leasing-dcms:
	kubectl -n leasing apply -f base/leasing/12_dcms.yaml

leasing-biz: leasing-server leasing-admin \
             leasing-worker leasing-dashboard

leasing-delete:
	kubectl delete namespace leasing

leasing-kustomize:
	kubectl kustomize base/leasing > special/common/leasing/leasing.yaml

leasing-special:
	kubectl -n leasing apply -f special/common/leasing/leasing.yaml

leasing-argocd:
	argocd app create leasing \
	  --port-forward-namespace argocd \
	  --repo git@e.coding.net:yantao0527/nuts/studio.git \
	  --path special/${SPECIAL_TARGET}/leasing \
	  --dest-server https://kubernetes.default.svc \
	  --dest-namespace leasing

leasing-tls:
	kubectl -n istio-system create secret tls leasing-tls \
	  --key ${SPECIAL_TARGET}/ssl/privkey.pem \
	  --cert ${SPECIAL_TARGET}/ssl/fullchain.pem

## DB utils

ifeq (${SPECIAL_TARGET}, laptop)
#MONGO_HOST=192.168.99.2
MONGO_HOST=z01.yantao0527.me
LEASING_DCMS_DIR=/home/frank/workgl/leasing-dcms
POSTGRES_SERVER=z01.yantao0527.me
endif

ifeq (${SPECIAL_TARGET}, gareninfo)
MONGO_HOST=172.17.0.1
#MONGO_HOST=gareninfo.net
LEASING_DCMS_DIR=/home/trial/workspace/leasing-dcms
POSTGRES_SERVER=gareninfo.net
endif



mongo-cli0:
	docker run -it --rm \
	  mongo:3.6.17 \
	  bash -c "mongo mongodb://admin:mcafee123@${MONGO_HOST}/admin"

mongo-init:
	${MAKE} leasing-mongo-watch
	docker run -it --rm \
	  mongo:3.6.17 \
	  mongo mongodb://admin:mcafee123@${MONGO_HOST}/admin --eval "db.getSiblingDB('leasing').createUser({user: 'admin', pwd: 'mcafee123', roles: [{role: 'dbOwner', db: 'leasing'}]})" 

mongo-cli:
	docker run -it --rm \
	  mongo:3.6.17 \
	  mongo mongodb://admin:mcafee123@${MONGO_HOST}/leasing

MONGO_DATAFILE=mongo_run2ai_20210521.tgz

mongo-datafile:
	rm -rf infrastructure/db/dump0
	scp yantao@run2ai.com:docker/mongodb/${MONGO_DATAFILE} infrastructure/db/${MONGO_DATAFILE}
	cd infrastructure/db; tar xvfz ${MONGO_DATAFILE}

mongo-restore:
	docker run --rm \
	  --network k3d-nuts \
	  -v ${PWD}/infrastructure/db:/mongodb \
	  mongo:3.6.17 \
	  mongorestore -h ${MONGO_HOST} --username=admin --password=mcafee123 --drop /mongodb/dump0

DCMS_IMAGE=registry.cn-hangzhou.aliyuncs.com/yantao0527/leasing-dcms:v0.3
#POSTGRES_IMAGE=postgres:10.7
POSTGRES_IMAGE=registry.localhost:5000/library/postgres:10.7

dcms-run:
	docker run -d --name leasing-dcms \
	  -p 21012:21012 \
      -p 21014:21014 \
      -p 21016:21016 \
      -p 22012:22012 \
      -p 23012:23012 \
      -p 23014:23014 \
      -v leasing_dcms_log:/opt/leasing/dcms/log \
      --network k3d-nuts \
      ${DCMS_IMAGE}

pg-run:
	docker run -d --name postgres \
	  -p 5432:5432 \
	  -e POSTGRES_PASSWORD=dcms \
	  -v pgdata:/var/lib/postgresql/data \
	  --network k3d-nuts \
	  ${POSTGRES_IMAGE}

pg-cli0:
	docker run -it --rm \
	  ${POSTGRES_IMAGE} \
	  psql -h ${POSTGRES_SERVER} -U postgres

pg-cli:
	docker run -it --rm \
	  ${POSTGRES_IMAGE} \
	  psql -h ${POSTGRES_SERVER} -U dcms

pg-cli2:
	docker run -it --rm \
	  -v ${LEASING_DCMS_DIR}/script:/script \
	  ${POSTGRES_IMAGE} \
	  sh

pg-init:
	${MAKE} leasing-postgres-watch
	export PROJECT_DIR=${LEASING_DCMS_DIR} && \
	export POSTGRES_IMAGE=${POSTGRES_IMAGE} && \
	export POSTGRES_SERVER=${POSTGRES_SERVER} && \
	infrastructure/db/pginit.sh

## ingredient
ingredient-init:
	${MAKE} leasing-mongo-watch
	docker run -it --rm \
	  mongo:3.6.17 \
	  mongo mongodb://admin:mcafee123@${MONGO_HOST}/admin --eval "db.getSiblingDB('ingredient').createUser({user: 'admin', pwd: 'mcafee123', roles: [{role: 'dbOwner', db: 'ingredient'}]})" 


