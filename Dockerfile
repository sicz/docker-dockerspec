ARG BASEIMAGE_NAME
ARG BASEIMAGE_TAG
FROM ${BASEIMAGE_NAME}:${BASEIMAGE_TAG}

ARG DOCKER_IMAGE_NAME
ARG DOCKER_TAG
ARG DOCKER_DESCRIPTION
ARG DOCKER_PROJECT_URL
ARG BUILD_DATE
ARG GITHUB_URL
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="${DOCKER_IMAGE_NAME}"
LABEL org.label-schema.version="${DOCKER_TAG}"
LABEL org.label-schema.description="${DOCKER_DESCRIPTION}"
LABEL org.label-schema.url="${DOCKER_PROJECT_URL}"
LABEL org.label-schema.vcs-url="${GITHUB_URL}"
LABEL org.label-schema.vcs-ref="${VCS_REF}"
LABEL org.label-schema.build-date="${BUILD_DATE}"

RUN set -ex \
  # Install Docker and packages needed for running tests
  && apk add --no-cache \
      docker \
      git \
      make \
      openssh-client \
  && docker --version \
  # Install docker-compose
  && apk add --no-cache python2 py2-pip \
  && pip install --upgrade pip \
  && pip install docker-compose \
  && apk del --no-cache py2-pip \
  && docker-compose --version \
  # Install rspec and serverspec
  && apk add --no-cache \
      ruby \
      ruby-io-console \
      ruby-irb \
      ruby-rdoc \
  && gem install \
      docker-api \
      rspec \
      serverspec \
  && rspec --version \
  && gem list -q serverspec \
  ;

ENV DOCKER_COMMAND="/usr/bin/rspec"
CMD ["/usr/bin/rspec"]
