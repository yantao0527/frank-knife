ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# ansible
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        make \
        openssh-client \
        python3-dev \
        python3-gssapi \
        python3-pip \
        python3-netaddr \
        python3-jmespath \
        python3-setuptools \
        python3-wheel
 
RUN pip install --upgrade pip \
    && pip install ansible
 
# istio argocd
RUN curl -sSL -o /usr/local/bin/istioctl https://dl-nuts.oss-cn-hangzhou.aliyuncs.com/istioctl-1.13.3 \
	&& chmod +x /usr/local/bin/istioctl \
	&& curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.1/argocd-linux-amd64 \
	&& chmod +x /usr/local/bin/argocd
