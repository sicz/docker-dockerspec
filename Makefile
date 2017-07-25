################################################################################

BASEIMAGE_NAME		= alpine
BASEIMAGE_TAG		?= 3.6

################################################################################

DOCKER_PROJECT		?= sicz
DOCKER_NAME		= dockerspec
DOCKER_TAG		?= $(BASEIMAGE_TAG)
DOCKER_TAGS		?= latest
DOCKER_DESCRIPTION	= An image intended to run Docker image tests using RSpec and ServerSpec
DOCKER_PROJECT_URL	= http://serverspec.org

DOCKER_BUILD_VARS	+= DOCKER_VERSION

DOCKER_RUN_CMD		= $(DOCKER_SHELL_CMD)
DOCKER_RUN_OPTS		+= $(DOCKER_SHELL_OPTS) \
			   -v $(abspath $(DOCKER_HOME_DIR))/spec:/spec \
			   -v /var/run/docker.sock:/var/run/docker.sock

DOCKER_SUBDIR		+= devel

################################################################################

DOCKER_VERSION		?= 17.06.0-ce

################################################################################

.PHONY: all build rebuild deploy run up destroy down rm start stop restart
.PHONY: status logs shell refresh test clean clean-all

all: destroy build deploy logs test
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
refresh: docker-refresh
test: docker-test
clean: destroy docker-clean
clean-all:
	@for SUBDIR in . $(DOCKER_SUBDIR); do \
		cd $(abspath $(DOCKER_HOME_DIR))/$${SUBDIR}; \
		$(MAKE) clean; \
	done

################################################################################

DOCKER_HOME_DIR		?= .
DOCKER_MK_DIR		?= $(DOCKER_HOME_DIR)/../Mk
include $(DOCKER_MK_DIR)/docker.container.mk

################################################################################
