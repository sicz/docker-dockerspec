################################################################################

BASEIMAGE_NAME		= sicz/baseimage-alpine
BASEIMAGE_TAG		?= 3.6

BUILDERIMAGE_NAME	= BASEIMAGE_NAME
BUILDERIMAGE_TAG	= BASEIMAGE_TAG

################################################################################

DOCKER_PROJECT		?= sicz
DOCKER_NAME		= dockerspec
DOCKER_TAG		?= $(BASEIMAGE_TAG)
DOCKER_TAGS		?= latest
DOCKER_DESCRIPTION	= An image intended to run Docker image tests using RSpec and ServerSpec
DOCKER_PROJECT_URL	= http://serverspec.org

DOCKER_BUILD_VARS	+= DOCKER_VERSION

DOCKER_RUN_CMD		= $(DOCKER_SHELL_CMD)
DOCKER_RUN_OPTS		+= -v /var/run/docker.sock:/var/run/docker.sock \
			   -v $(abspath $(DOCKER_HOME_DIR))/spec:/spec \
			   $(DOCKER_SHELL_OPTS)

DOCKER_SUBDIR		+= devel

################################################################################

# Docker Compose file version:
# - docker: 3.3
# - docker-compose: 3.3
DOCKER_VERSION		?= 17.06.0-ce
DOCKER_COMPOSE_VERSION	?= 1.15.0

################################################################################

.PHONY: all info clean clean-all
.PHONY: build rebuild deploy run up destroy down rm start stop restart
.PHONY: status logs shell test

all: destroy build test
info: docker-info github-info
build: docker-build
rebuild: docker-rebuild
deploy run up: docker-deploy
destroy down rm: docker-destroy
start: docker-start
stop: docker-stop
restart: docker-stop docker-start
status: docker-status
logs: docker-logs
logs-tail: docker-logs-tail
shell: docker-shell
test: start docker-test
clean: destroy docker-clean
clean-all: ; @$(MAKE) docker-all TARGET=clean

################################################################################

DOCKER_HOME_DIR		?= .
DOCKER_MK_DIR		?= $(DOCKER_HOME_DIR)/../Mk
include $(DOCKER_MK_DIR)/docker.container.mk

################################################################################
