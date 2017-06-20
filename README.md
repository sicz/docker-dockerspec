# docker-dockerspec

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-dockerspec.svg?style=shield&circle-token=5b2ef1ced1877b03440694e44544e33b70ba74ce)](https://circleci.com/gh/sicz/docker-dockerspec)

**This project is not aimed at public consumption.
It exists to support the development of SICZ containers.**

An image intended to run Docker integration tests using RSpec.

## Contents

This container only contains essential components:
* Official [Alpine Linux image](https://store.docker.com/images/alpine) as base system
* Modular [Docker entrypoint](https://github.com/sicz/docker-entrypoint)
* [Docker](https://www.docker.com) provides Docker command line tools
* [RSpec](http://rspec.info) provides Ruby testing framework
* [ServerSpec](http://serverspec.org) provides server testing framework for RSpec
* [DockerSpec](https://github.com/zuazo/dockerspec) provides Docker pluging for ServerSpec
* `bash` as shell
* `ca-certificates` contains common CA certificates
* `curl` for transferring data using various protocols
* `jq` for JSON data parsing
* `libressl` for PKI and TLS
* `runit` for service supervision and management
* `su_exec` for process impersonation
* `tini` as init process

## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes
on how to deploy the project on a live system.

### Installing

Clone GitHub repository to your working directory:
```bash
git clone https://github.com/sicz/docker-dockerspec
```

### Usage

Use command `make` to simplify Docker container development tasks:
```bash
make all        # Destroy running container, build new image and run tests
make build      # Build new image
make refresh    # Refresh Dockerfile
make rebuild    # Build new image without caching
make run        # Run container
make stop       # Stop running container
make start      # Start stopped container
make restart    # Restart container
make status     # Show container status
make logs       # Show container logs
make logs-tail  # Connect to container logs
make shell      # Open shell in running container
make test       # Run tests
make rm         # Destroy running container
make clean      # Destroy running container and clean
```

## Deployment

At first init RSpec configuration for your project:
```bash
docker run \
  -v ${PWD}:/root \
  -w /root \
  --rm \
  sicz/dockerspec --init
```
and create your tests in `spec` directory. For inspiration you can look at our
[Docker projects at GitHub](https://github.com/sicz).

With [sicz/Mk](https://github.com/sicz/Mk) you can test your Docker image with
simple command:
```bash
make test
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of
[contributors](https://github.com/sicz/docker-baseimage-alpine/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.

## Acknowledgments

This Docker image was inspired by
[Test Driven Development of Dockerfile](https://github.com/tcnksm-sample/test-driven-development-dockerfile).
