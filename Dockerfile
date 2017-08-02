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

ARG DOCKER_VERSION

RUN set -ex \
  # Install packages needed to runn the tests
  && apk add --no-cache \
      git \
      make \
      openssh-client \
      python2 \
      ruby \
      ruby-io-console \
      ruby-irb \
      ruby-rdoc \
  # Install Docker
  && curl -fL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
   | tar -xz -C /tmp -f - \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker \
  && docker --version \
  # Install Docker Compose
  && apk add --no-cache --virtual .build-dependencies \
      py2-pip \
  && pip install --upgrade pip \
  && pip install docker-compose \
  && apk del --no-cache .build-dependencies \
  && docker-compose --version \
  # Install rspec and serverspec
  && gem install \
      docker-api \
      rspec \
      serverspec \
  && gem list -q docker-api \
  && gem list -q rspec \
  && gem list -q serverspec \
  && rspec --version \
  && rm -rf /root/.cache /root/.gem \
  ;

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

ENV DOCKER_COMMAND="/usr/bin/rspec"
CMD ["/usr/bin/rspec"]
