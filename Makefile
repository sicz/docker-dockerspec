ALPINE_VERSION		?= latest
DOCKERSPEC_VERSION	?= 17.04.24
DOCKER_VERSION		= 17.03.1-ce
DOCKER_TARBALL_SHA256	= 820d13b5699b5df63f7032c8517a5f118a44e2be548dd03271a86656a544af55

BASE_IMAGE_TAG		= $(ALPINE_VERSION)

DOCKER_PROJECT		= sicz
DOCKER_NAME		= dockerspec
DOCKER_TAG		= 17.04.24
DOCKER_FILE_SUB		+= DOCKER_VERSION \
			   DOCKER_TARBALL_SHA256

DOCKER_RUN_OPTS		= $(DOCKER_SHELL_OPTS) \
			  -v $(CURDIR)/spec:/spec \
			  -v /var/run/docker.sock:/var/run/docker.sock
DOCKER_RUN_CMD		+= $(DOCKER_SHELL_CMD)

.PHONY: all build rebuild deploy run up destroy down clean rm start stop restart
.PHONY: status logs shell refresh test

all: destroy build deploy logs
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
