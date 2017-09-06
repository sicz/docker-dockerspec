### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_PROJECT)/baseimage-alpine
BASE_IMAGE_TAG		?= 3.6

### DOCKER_IMAGE ###############################################################

DOCKER_NAME		?= dockerspec
DOCKER_PROJECT_DESC	?= An image intended to run Docker image tests using RSpec and ServerSpec
DOCKER_PROJECT_URL	?= http://serverspec.org

DOCKER_IMAGE_TAG	?= $(GEM_SERVERSPEC_VERSION)
DOCKER_IMAGE_TAGS	?= latest

### DOCKER_VERSIONS ############################################################

DOCKER_VERSIONS		?= latest devel

### BUILD ######################################################################

# Docker image build variables
BUILD_VARS		+= DOCKER_VERSION \
			   DOCKER_COMPOSE_VERSION \
			   GEM_DOCKER_API_VERSION \
			   GEM_RSPEC_VERSION \
			   GEM_SPECINFRA_VERSION \
			   GEM_SERVERSPEC_VERSION \
			   RUBY_VERSION

# Supported Docker Compose file versions:
# - docker-17.06.0: 3.3
# - docker-compose-1.15.0: 3.3
DOCKER_VERSION		?= 17.06.1-ce
DOCKER_COMPOSE_VERSION	?= 1.15.0

RUBY_VERSION		?= 2.4.1

GEM_DOCKER_API_VERSION	?= 1.33.6
GEM_RSPEC_VERSION	?= 3.6.0
GEM_SPECINFRA_VERSION	?= 2.71.1
GEM_SERVERSPEC_VERSION	?= 2.40.0

### DOCKER_EXECUTOR ############################################################

# Use the Docker Compose executor
DOCKER_EXECUTOR		?= compose

# Use the same service name for all configurations
SERVICE_NAME		?= container

### TEST #######################################################################

# Use itself version for tests
TEST_IMAGE_TAG		?= $(DOCKER_IMAGE_TAG)

### MAKE_TARGETS ###############################################################

# Build a new image and run tests for current configuration
.PHONY: all
all: build clean start wait logs test

# Build a new image and run tests for all configurations
.PHONY: ci
ci: all
	@$(MAKE) clean

### BUILD_TARGETS ##############################################################

# Build a new image with using the Docker layer caching
.PHONY: build
build: docker-build

# Build a new image without using the Docker layer caching
.PHONY: rebuild
rebuild: docker-rebuild

### EXECUTOR_TARGETS ###########################################################

# Display the configuration file for the current configuration
.PHONY: config-file
config-file: display-config-file

# Display the make variables for the current configuration
.PHONY: makevars vars
makevars vars: display-makevars

# Remove the containers and then run them fresh
.PHONY: run up
run up: docker-up

# Create the containers
.PHONY: create
create: docker-create

# Start the containers
.PHONY: start
start: create docker-start

# Wait for the start of the containers
.PHONY: wait
wait: start docker-wait

# Display running containers
.PHONY: ps
ps: docker-ps

# Display the container logs
.PHONY: logs
logs: docker-logs

# Follow the container logs
.PHONY: logs-tail tail
logs-tail tail: docker-logs-tail

# Run the shell in the container
.PHONY: shell sh
shell sh: start docker-shell

# Run the current configuration tests
.PHONY: test
test: start docker-test

# Run the shell in the test container
.PHONY: test-shell tsh
test-shell tsh:
	@$(MAKE) test TEST_CMD=/bin/bash

# Stop the containers
.PHONY: stop
stop: docker-stop

# Restart the containers
.PHONY: restart
restart: stop start

# Remove the containers
.PHONY: down rm
down rm: docker-rm

# Remove all containers and work files
.PHONY: clean
clean: docker-clean

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(CURDIR)
MK_DIR			?= $(PROJECT_DIR)/../Mk
include $(MK_DIR)/docker.image.mk

################################################################################
