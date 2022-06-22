# FROM ubuntu:focal
# ENV DEBIAN_FRONTEND noninteractive
# ENV TF_VERSION 1.1.7
# ENV PACKER_VERSION 1.8.0
 
# ENV pip_packages "ansible cryptography pywinrm kerberos requests_kerberos passlib msrest PyVmomi pymssql"
 
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         apt-transport-https \
#         make \
#         gcc \
#         ca-certificates \
#         curl \
#         git \
#         gnupg \
#         jq \
#         krb5-user \
#         krb5-config \
#         libffi-dev \
#         libkrb5-dev \
#         libssl-dev \
#         lsb-release \
#         openssh-client \
#         python3-dev \
#         python3-gssapi \
#         python3-pip \
#         python3-netaddr \
#         python3-jmespath \
#         python3-setuptools \
#         python3-wheel \
#         python3-pymssql \
#         sshpass \
#         unzip \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
#     && apt-get clean
 
# RUN pip install --upgrade pip \
#     && pip install $pip_packages \
#     && pip install ansible[azure] \
#     && ansible-galaxy collection install azure.azcollection community.general \
#     && pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
 
# RUN curl -O https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
#     && unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/bin \
#     && rm -f terraform_${TF_VERSION}_linux_amd64.zip \
#     && chmod +x /usr/bin/terraform \
#     && curl -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
#     && unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin \
#     && rm -f packer_${PACKER_VERSION}_linux_amd64.zip \
#     && chmod +x /usr/bin/packer
 
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# CMD    ["/bin/bash"]


# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version (use ubuntu-22.04 or ubuntu-18.04 on local arm64/Apple Silicon): ubuntu-22.04, ubuntu-20.04, ubuntu-18.04
ARG VARIANT="jammy"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

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
