
ACME_IMAGE=neilpang/acme.sh:2.9.0

check-domain:
ifndef KNIFE_DOMAIN
	$(error 请执行 source ../base/env.sh 或手动配置 KNIFE_DOMAIN)
endif

check-alicloud:
ifndef ALICLOUD_ACCESS_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_ACCESS_KEY)
endif
ifndef ALICLOUD_SECRET_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_SECRET_KEY)
endif

check-aws:
ifndef AWS_ACCESS_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 AWS_ACCESS_KEY)
endif
ifndef AWS_SECRET_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 AWS_SECRET_KEY)
endif

help:
	docker run --rm  -it  \
	  -v "$(PWD)/out":/acme.sh  \
	  $(ACME_IMAGE) --issue --help

issue-ali: check-domain check-alicloud
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		-e Ali_Key=$(ALICLOUD_ACCESS_KEY) \
		-e Ali_Secret=$(ALICLOUD_SECRET_KEY) \
		$(ACME_IMAGE) --issue --log --dns dns_ali \
		-d nuts.$(KNIFE_DOMAIN) \
		-d *.nuts.$(KNIFE_DOMAIN)

issue-aws: check-domain check-aws
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY) \
		$(ACME_IMAGE) --issue --log --dns dns_aws \
		-d nuts.$(KNIFE_DOMAIN) \
		-d *.nuts.$(KNIFE_DOMAIN)

nginx-cert: check-domain
	-sudo mkdir out/nginx
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		$(ACME_IMAGE) --install-cert --log -d nuts.$(KNIFE_DOMAIN) \
		--key-file /acme.sh/nginx/privkey.pem \
		--fullchain-file /acme.sh/nginx/fullchain.pem

renew: check-domain
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		$(ACME_IMAGE) --renew --log

copy-cert:
	-mkdir ../k8s_base/certs/nuts.$(KNIFE_DOMAIN)
	sudo cp out/nginx/*.pem ../k8s_base/certs/nuts.$(KNIFE_DOMAIN)
	sudo chown $(shell id -un):$(shell id -gn) ../k8s_base/certs/nuts.$(KNIFE_DOMAIN)/*.pem

issue-aws-argocd: check-domain check-aws
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_KEY) \
		$(ACME_IMAGE) --issue --log --dns dns_aws \
		-d argocd.nuts.$(KNIFE_DOMAIN)

nginx-cert-argocd: check-domain
	-sudo mkdir out/nginx
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		$(ACME_IMAGE) --install-cert --log -d argocd.nuts.$(KNIFE_DOMAIN) \
		--key-file /acme.sh/nginx/privkey.pem \
		--fullchain-file /acme.sh/nginx/fullchain.pem

copy-cert-argocd:
	-mkdir ../k8s_base/certs/argocd.nuts.$(KNIFE_DOMAIN)
	sudo cp out/nginx/*.pem ../k8s_base/certs/argocd.nuts.$(KNIFE_DOMAIN)
	sudo chown $(shell id -un):$(shell id -gn) ../k8s_base/certs/argocd.nuts.$(KNIFE_DOMAIN)/*.pem

