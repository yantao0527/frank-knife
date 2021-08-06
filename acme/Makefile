
DOMAIN=yantao0527.me
ACME_IMAGE=neilpang/acme.sh:2.9.0

check-access:
ifndef ALICLOUD_ACCESS_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_ACCESS_KEY)
endif

check-secret:
ifndef ALICLOUD_SECRET_KEY
	$(error 请执行 source ../base/env.sh 或手动配置 ALICLOUD_SECRET_KEY)
endif

help:
	docker run --rm  -it  \
	  -v "$(PWD)/out":/acme.sh  \
	  $(ACME_IMAGE) --issue --help

issue: check-access check-secret
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		-e Ali_Key=$(ALICLOUD_ACCESS_KEY) \
		-e Ali_Secret=$(ALICLOUD_SECRET_KEY) \
		$(ACME_IMAGE) --issue --log --dns dns_ali \
		-d nuts.$(DOMAIN) \
		-d *.nuts.$(DOMAIN)

install-cert:
	-sudo mkdir out/nginx
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		$(ACME_IMAGE) --install-cert --log -d nuts.yantao0527.me \
		--key-file /acme.sh/nginx/privkey.pem \
		--fullchain-file /acme.sh/nginx/fullchain.pem
	sudo cp out/nginx/*.pem ../k8s_base/certs/nuts.yantao0527.me
	sudo chown $(shell id -un):$(shell id -gn) ../k8s_base/certs/nuts.yantao0527.me/*.pem

renew:
	docker run --rm  -it  \
		-v "$(PWD)/out":/acme.sh  \
		$(ACME_IMAGE) --renew --log \
		-d nuts.$(DOMAIN) \
		-d *.nuts.$(DOMAIN)

