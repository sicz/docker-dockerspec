# docker-dockerspec

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-dockerspec.svg?style=shield&circle-token=5b2ef1ced1877b03440694e44544e33b70ba74ce)](https://circleci.com/gh/sicz/docker-dockerspec)

**This project is not aimed at public consumption.
It exists to serve as a single endpoint for SICZ containers.**

An image intended to run Docker image tests using RSpec and ServerSpec.

## Contents

This image contains tools for testing Docker images:
* [sicz/baseimage-alpine](https://github.com/sicz/docker-baseimage-alpine)
  as a base image.
* [Docker](https://docs.docker.com/engine/) provides a Docker command line tools
  and engine
* [Docker Compose](https://docs.docker.com/compose/) provides a Docker Compose
  command line tools
* [RSpec](http://rspec.info) provides a Ruby testing framework
* [ServerSpec](http://serverspec.org) provides a server testing framework for
  RSpec
* [Docker API](https://github.com/swipely/docker-api) provides an interface for
  Docker Remote API
<!--
* [Dockerspec](https://github.com/zuazo/dockerspec) provides Docker plugin for ServerSpec
-->
## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See [Deployment](#deployment)
for notes on how to deploy the project on a live system.

### Installing

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/sicz/docker-dockerspec
```

### Usage

Use the command `make` in the project directory:
```bash
make all                      # Build a new image and run the tests
make ci                       # Build a new image and run the tests
make build                    # Build a new image
make rebuild                  # Build a new image without using the Docker layer caching
make config-file              # Display the configuration file for the current configuration
make vars                     # Display the make variables for the current configuration
make up                       # Remove the containers and then run them fresh
make create                   # Create the containers
make start                    # Start the containers
make stop                     # Stop the containers
make restart                  # Restart the containers
make rm                       # Remove the containers
make wait                     # Wait for the start of the containers
make ps                       # Display running containers
make logs                     # Display the container logs
make logs-tail                # Follow the container logs
make shell                    # Run the shell in the container
make test                     # Run the tests
make test-shell               # Run the shell in the test container
make clean                    # Remove all containers and work files
make docker-pull              # Pull all images from the Docker Registry
make docker-pull-baseimage    # Pull the base image from the Docker Registry
make docker-pull-dependencies # Pull the project image dependencies from the Docker Registry
make docker-pull-image        # Pull the project image from the Docker Registry
make docker-pull-testimage    # Pull the test image from the Docker Registry
make docker-push              # Push the project image into the Docker Registry
```

## Deployment

You can test your container with commands:
```bash
cd MY_IMAGE
docker run -d --name=my_container MY_IMAGE
docker run -t \
  -e CONTAINER_NAME=my_container \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD:/root/project \
  -w /root/project \
  --rm \
  sicz/dockerspec --format=doc
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of
[contributors](https://github.com/sicz/docker-baseimage-alpine/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.
