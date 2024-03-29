SPECIAL_TARGET=aws
#SPECIAL_TARGET=laptop
DOMAIN=nuts.$(KNIFE_DOMAIN)

include Makefile.mk

## Quickly setup platform

platform: istio argocd argocd-wait argocd-post argocd-apps


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

argocd-wait:
	kubectl -n argocd wait deploy/argocd-redis --for condition=available --timeout=60s
	kubectl -n argocd wait deploy/argocd-repo-server --for condition=available --timeout=60s
	kubectl -n argocd wait deploy/argocd-dex-server --for condition=available --timeout=60s
	kubectl -n argocd wait deploy/argocd-server --for condition=available --timeout=60s

argocd-delete:
	kubectl delete namespace argocd
	kubectl -n istio-system delete secret argocd-tls
	
#--- argocd-apps ---

argocd-apps-base:
	kubectl -n argocd apply -k base/apps
	
argocd-apps-kustomize:
	kubectl kustomize overlays/${SPECIAL_TARGET}/apps > special/${SPECIAL_TARGET}/apps/apps.yaml

argocd-apps-special:
	kubectl -n argocd apply -f special/${SPECIAL_TARGET}/apps/apps.yaml
	
argocd-apps: website-pre website-tls gitea-pre \
             vault-pre jx3-pre observability-pre \
             argocd-apps-special
			 
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

VAULT_NAMESPACE=jx-vault

vault-pre:
	kubectl create namespace jx-vault
	kubectl label namespace jx-vault istio-injection=enabled

vault-base:
	helmfile --file base/vault/helmfile_vault.yaml apply

vault-base-delete:
	helmfile --file base/vault/helmfile_vault.yaml destroy

vault-build:
	rm -rf special/common/vault
	mkdir special/common/vault
	helmfile --file base/vault/helmfile_vault.yaml template --include-crds --output-dir-template $(PWD)/special/common/vault

vault-special:
	kubectl -n jx-vault apply -f special/common/vault --recursive=true

vault-status:
	kubectl -n jx-vault get pod

vault-delete:
	kubectl -n jx-vault delete -f special/common/vault --recursive=true
	kubectl delete namespace jx-vault

vault-ca:
	kubectl -n $(VAULT_NAMESPACE) get secret vault-tls \
	  -o jsonpath="{.data.ca\.crt}" | base64 --decode > $(PWD)/vault_ca.crt

vault-root-token:
	kubectl -n $(VAULT_NAMESPACE) get secrets vault-unseal-keys \
	  -o jsonpath={.data.vault-root} | base64 --decode && echo

vault-argocd-app-:
	kubectl apply -f base/vault/app_vault.yaml

vault-argocd-app: vault-pre vault-argocd-app-

vault-ui:
	kubectl -n $(VAULT_NAMESPACE) apply -f base/vault/expose_vault_ui.yaml

## jx3

check-token:
ifndef GITHUB_TOKEN_JX3
	$(error 请执行 source $$HOME/bin/env.sh 或手动配置 GITHUB_TOKEN_JX3)
endif

jx3-pre:
	kubectl create namespace jx-git-operator

jx3-repo:
	helm repo add jxgh https://jenkins-x-charts.github.io/repo
	helm repo update

jx3-helm: check-token
	helm upgrade --install jxgo jxgh/jx-git-operator \
	  --namespace jx-git-operator --create-namespace \
	  --values helm/${SPECIAL_TARGET}/jx-git-operator/values.yam \
	  --set password=${GITHUB_TOKEN_JX3}

jx3-build: check-token
	rm -rf special/${SPECIAL_TARGET}/jx-git-operator
	helm template jxgo jxgh/jx-git-operator \
	  --namespace jx-git-operator --create-namespace \
	  --values helm/${SPECIAL_TARGET}/jx-git-operator/values.yaml \
	  --set password=${GITHUB_TOKEN_JX3} \
	  --output-dir $(PWD)/special/${SPECIAL_TARGET}

jx3-special:
	kubectl -n jx-git-operator apply -f special/${SPECIAL_TARGET}/jx-git-operator --recursive=true

jx3-argocd-app: jx3-pre
	cd .. && \
	argocd app create jx-git-operator \
	  --port-forward-namespace argocd \
	  --project nuts \
	  --repo https://github.com/yantao0527/frank-knife.git \
	  --path k8s_base/special/${SPECIAL_TARGET}/jx-git-operator \
	  --directory-recurse \
	  --dest-server https://kubernetes.default.svc \
	  --dest-namespace jx-git-operator

## gitea

gitea-pre:
	kubectl create namespace git
	kubectl label namespace git istio-injection=enabled

gitea-base:
	helmfile --file base/gitea/helmfile_gitea.yaml apply

gitea-build:
	rm -rf special/${SPECIAL_TARGET}/gitea
	mkdir special/${SPECIAL_TARGET}/gitea
	helmfile --file base/gitea/helmfile_gitea.yaml template --include-crds --output-dir-template $(PWD)/special/${SPECIAL_TARGET}

gitea-special:
	kubectl -n git apply -f special/${SPECIAL_TARGET}/gitea

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


## observability

observability-pre:
	kubectl create namespace jx-observability

observability-base:
	helmfile --file helmfile/observability/helmfile.yaml apply


observability-build:
	rm -rf special/common/observability
	mkdir special/common/observability
	helmfile --file helmfile/observability/helmfile.yaml template --validate --include-crds --output-dir-template $(PWD)/special/common/observability

observability-special:
	kubectl -n jx-observability apply -f special/common/observability --recursive=true

observability-delete:
	kubectl delete namespace jx-observability

grafana-password:
	kubectl -n jx-observability get secret grafana --template='{{index .data "admin-password"}}' | base64 --decode && echo

grafana-istio:
	kubectl -n jx-observability apply -f base/observability/grafana_istio_cm.yaml

observability-argocd-app: observability-pre
	cd .. && \
	argocd app create observability \
	  --port-forward-namespace argocd \
	  --project nuts \
	  --repo https://github.com/yantao0527/frank-knife.git \
	  --path k8s_base/special/common/observability \
	  --directory-recurse \
	  --dest-server https://kubernetes.default.svc \
	  --dest-namespace jx-observability

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


