reg_name=registry.localhost
reg_port=5000

registry-volume:
	docker volume create nuts_registry

registry0:
	docker run -d \
	  --name "${reg_name}" \
	  --restart=always \
	  -p "${reg_port}:${reg_port}" \
	  -e REGISTRY_PROXY_REMOTEURL="https://registry-1.docker.io" \
	  -v nuts_registry:/var/lib/registry \
	  registry:2

registry:
	docker run -d \
	  --name "${reg_name}" \
	  --restart=always \
	  -p "${reg_port}:${reg_port}" \
	  -e REGISTRY_PROXY_REMOTEURL="https://2wud1uac.mirror.aliyuncs.com" \
	  -v nuts_registry:/var/lib/registry \
	  registry:2

registry-delete:
	docker stop ${reg_name}
	docker rm ${reg_name}

registry-network:
	docker network connect k3d-nuts "${reg_name}"

registry-catalog:
	curl http://registry.localhost:5000/v2/_catalog

## K3D

# 无VPN，适合国外
create0:
	k3d cluster create \
	  --config ${PWD}/infrastructure/k3d_config0.yaml \
	  --registry-config ${PWD}/registries.yaml \
	  --volume ${PWD}:/nuts@all

# 适应国内网络环境
create:
	k3d cluster create \
	  --env "HTTPS_PROXY=${HTTPS_PROXY}"@all \
	  --env "NO_PROXY=.svc"@all \
	  --config ${PWD}/k3d_config.yaml \
	  --registry-config ${PWD}/registries.yaml \
	  --volume ${PWD}:/nuts@all

delete:
	k3d cluster delete nuts