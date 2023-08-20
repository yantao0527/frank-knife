
volume-main:
	docker volume create concierge_main

run:
	docker run --name concierge \
		--env-file ./frank.env \
		-v concierge_main:/main \
		-w /main \
		dragondropcloud/cloud-concierge:latest

rm:
	docker rm concierge

logs:
	docker logs concierge

copy-json:
	docker cp concierge:/main/mappings .

run2:
	docker run -it --rm \
		-v concierge_main:/main \
		-w /main \
		busybox:latest sh