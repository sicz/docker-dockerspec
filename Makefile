ALPINE_VERSION		?= latest
DOCKERSPEC_VERSION	?= $(ALPINE_VERSION)

BASE_IMAGE_TAG		= $(ALPINE_VERSION)

DOCKER_PROJECT		= sicz
DOCKER_NAME		= dockerspec
DOCKER_TAG		= ${DOCKERSPEC_VERSION}

DOCKER_RUN_OPTS		= $(DOCKER_SHELL_OPTS) \
			  -v $(CURDIR)/spec:/spec \
			  -v /var/run/docker.sock:/var/run/docker.sock
DOCKER_RUN_CMD		+= $(DOCKER_SHELL_CMD)

.PHONY: all build rebuild deploy run up destroy down clean rm start stop restart
.PHONY: status logs shell refresh test

all: destroy build deploy logs test
build: docker-build
rebuild: docker-rebuild
deploy run up: docker-deploy
destroy down clean rm: docker-destroy
start: docker-start
stop: docker-stop
restart: docker-stop docker-start
status: docker-status
logs: docker-logs
logs-tail: docker-logs-tail
shell: docker-shell
refresh: docker-refresh
test: docker-test

include ../Mk/docker.container.mk
