
ISTIO_VERSION=1.10.0
ISTIO_SPACE=istio-${ISTIO_VERSION}

istio-download0:
	cd ${HOME}/workspace && \
	  curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh - && \
	  cp ${ISTIO_SPACE}/bin/istioctl ${HOME}/bin


ISTIO_DOWNLOAD=https://dl-nuts.oss-cn-hangzhou.aliyuncs.com/istioctl-${ISTIO_VERSION}

istio-download:
	sudo curl -sSL -o /usr/local/bin/istioctl ${ISTIO_DOWNLOAD}
	sudo chmod +x /usr/local/bin/istioctl

istio:
	istioctl install -f profile_istio.yaml -y

istio-delete:
	kubectl delete namespace istio-system

istio-addons-base:
	kubectl apply -k base/addons
	
istio-addons-kustomize:
	kubectl kustomize base/addons > special/common/addons/addons.yaml

istio-addons-special:
	kubectl -n istio-system apply -f special/common/addons/addons.yaml

#ARGOCD_DOWNLOAD=https://github.com/argoproj/argo-cd/releases/download/v2.0.1/argocd-linux-amd64
ARGOCD_DOWNLOAD=https://dl-nuts.oss-cn-hangzhou.aliyuncs.com/argocd-linux-amd64
ARGOCD_PASSWORD := admin123

ifeq (${SPECIAL_TARGET}, laptop)
ARGOCD_SERVER=argocd.z01.yantao0527.me
endif

ifeq (${SPECIAL_TARGET}, nuts)
ARGOCD_SERVER=argocd.nuts.yantao0527.me
endif

argocd-cli:
	sudo curl -sSL -o /usr/local/bin/argocd ${ARGOCD_DOWNLOAD}
	sudo chmod +x /usr/local/bin/argocd

argocd-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd_password.txt

argocd-login:
	argocd login ${ARGOCD_SERVER} --port-forward-namespace argocd --username admin --password ${shell cat argocd_password.txt}

argocd-update-password:
	argocd account update-password --port-forward-namespace argocd --current-password ${shell cat argocd_password.txt} --new-password admin123


## loki

loki-repo:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

loki-pre:
	kubectl create namespace loki

loki:
	helm upgrade --install loki --namespace=loki grafana/loki

# http://127.0.0.1:3100/api/prom/label
loki-expose:
	kubectl --namespace loki port-forward service/loki 3100

promtail:
	helm upgrade --install promtail --namespace=loki grafana/promtail --set "loki.serviceName=loki"

# http://127.0.0.1:3101/metrics
promtail-expose:
	kubectl --namespace loki port-forward daemonset/promtail 3101

promtail-config-get:
	kubectl -n loki get secret promtail -o jsonpath="{.data.promtail\.yaml}" | base64 -d && echo

promtail-config:
	kubectl -n loki delete secret promtail
	kubectl -n loki create secret generic promtail --from-file=promtail.yaml=base/loki/promtail_config.yaml


## install cert-manager

cert-manager-repo:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update

cert-manager:
	helm upgrade cert-manager jetstack/cert-manager \
	  --install --create-namespace \
	  --namespace cert-manager \
	  --set installCRDs=true \
	  --wait

cert-manager-status:
	kubectl -n cert-manager rollout status deploy/cert-manager
	kubectl -n cert-manager get all


## Dashboard

dashboard:
	kubectl apply -f base/dashboard/dashboard_v2.2.0.yaml

#	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

dashboard-user:
	kubectl apply -f base/dashboard/admin_user.yaml

dashboard-token:
	kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token
	
