ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG RUBY_VERSION
ARG GEM_DOCKER_API_VERSION
ARG GEM_RSPEC_VERSION
ARG GEM_SPECINFRA_VERSION
ARG GEM_SERVERSPEC_VERSION

ENV \
  DOCKER_COMMAND="/usr/bin/rspec"

RUN set -exo pipefail; \
  # Install the packages
  apk add --no-cache \
    git \
    make \
    nmap \
    nmap-nping \
    nmap-nselibs \
    nmap-scripts \
    openssh-client \
    python2 \
    "ruby>${RUBY_VERSION}" \
    "ruby-io-console>${RUBY_VERSION}" \
    "ruby-irb>${RUBY_VERSION}" \
    "ruby-rdoc>${RUBY_VERSION}" \
    ; \
  # Install Docker
  curl -fL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
   | tar xfz - -C /tmp; \
  mv /tmp/docker/* /usr/bin; \
  rm -rf /tmp/docker; \
  docker --version; \
  # Install build dependencies
  apk add --no-cache --virtual .build-dependencies \
    gcc \
    musl-dev \
    py2-pip \
    ruby-dev \
    ; \
  # Install Docker Compose
  pip install --upgrade pip; \
  pip install docker-compose==${DOCKER_COMPOSE_VERSION}; \
  docker-compose --version; \
  # Install rspec and serverspec
  gem install \
    etc \
    docker-api:${GEM_DOCKER_API_VERSION} \
    rspec:${GEM_RSPEC_VERSION} \
    specinfra:${GEM_SPECINFRA_VERSION} \
    serverspec:${GEM_SERVERSPEC_VERSION} \
    ; \
  gem list --local --quiet \
    docker-api \
    rspec \
    specinfra \
    serverspec \
    ; \
  rm -rf /root/.cache /root/.gem; \
  # Remove build dependencies
  apk del --no-cache .build-dependencies
