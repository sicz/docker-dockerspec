FROM alpine:3.6

ENV org.label-schema.schema-version="1.0"
ENV org.label-schema.name="sicz/dockerspec"
ENV org.label-schema.description="An image intended to run Docker integration tests using RSpec."
ENV org.label-schema.build-date="2017-05-26T14:24:46Z"
ENV org.label-schema.url="http://serverspec.org"
ENV org.label-schema.vcs-url="https://github.com/sicz/docker-dockerspec"

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
  && curl -fLO https://github.com/sicz/docker-entrypoint/archive/master.tar.gz \
  && tar xfz master.tar.gz \
  && cp -r docker-entrypoint-master/config/* / \
  && rm -rf master.tar.gz docker-entrypoint-master \
  && chmod +x /docker-entrypoint.sh \
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
  # Install rspec
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

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
ENV DOCKER_COMMAND="rspec"
CMD ["rspec"]
