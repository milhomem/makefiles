.PHONY : docker-build docker-build-push

DOCKER ?= $(shell command -v docker 2> /dev/null || echo docker)

DOCKER_BUILD_CONTEXT ?= build/
docker-build: build/Dockerfile
ifndef DOCKER_HOST
	$(error You need to have a docker daemon running in this terminal)
endif
	$(DOCKER) build --file $^ --tag $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) --tag $(DOCKER_IMAGE):latest $(DOCKER_BUILD_CONTEXT)
	rm $^

docker-build-push:
	$(DOCKER) push $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)
	$(DOCKER) push $(DOCKER_IMAGE):latest

docker_run = $(DOCKER) run --rm $3 $(strip $2) $(strip 1)
