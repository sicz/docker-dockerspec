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

# Keep in sync with:
# - https://github.com/sicz/docker-baseimage-alpine
# - https://github.com/sicz/docker-baseimage-centos
# - https://github.com/sicz/docker-dockerspec
RUN set -ex \
  # Upgrade system
  && apk upgrade --no-cache \
  # Install base image packages
  && apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      jq \
      libressl \
      runit \
      su-exec \
      tini \
  # Make bash more friendly
  && echo 'alias ll="ls -al"' >> /etc/bash.bashrc \
  && echo '. /etc/bash.bashrc' >> /root/.bashrc \
  && echo '"\e[A": history-search-backward' >> /etc/inputrc \
  && echo '"\e[B": history-search-forward' >> /etc/inputrc \
  && echo 'if [ -f ~/.bashrc ]; then . ~/.bashrc; fi' >> /root/.bash_profile \
  && bash --version \
  # Install modular Docker entrypoint
  && curl -fL https://github.com/sicz/docker-entrypoint/archive/master.tar.gz \
   | tar -xz -C /tmp -f - \
  && cp -rp /tmp/docker-entrypoint-master/config/* / \
  && rm -rf /tmp/docker-entrypoint-master \
  && chmod +x /docker-entrypoint.sh \
  ;

ARG DOCKER_VERSION

RUN set -ex \
  # Install packages needed for running tests
  && apk add --no-cache \
      git \
      make \
      openssh-client \
  # Install Docker
  && curl -fL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
   | tar -xz -C /tmp -f - \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker \
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
  && gem list -q docker-api \
  && gem list -q rspec \
  && gem list -q serverspec \
  && rspec --version \
  ;

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]

ENV DOCKER_COMMAND="/usr/bin/rspec"
CMD ["/usr/bin/rspec"]
