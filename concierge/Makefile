
volume-main:
	docker volume create concierge_main

run:
	docker run --env-file ./frank.env -v concierge_main:/main -w /main  dragondropcloud/cloud-concierge:latest