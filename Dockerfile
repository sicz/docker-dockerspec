FROM sicz/baseimage-alpine:3.5

ENV org.label-schema.schema-version="1.0"
ENV org.label-schema.name="sicz/dockerspec"
ENV org.label-schema.description="An image intended to run Docker integration tests using RSpec."
ENV org.label-schema.build-date="2017-04-24T00:23:02Z"
ENV org.label-schema.url="https://alpinelinux.org"
ENV org.label-schema.vcs-url="https://github.com/sicz/docker-dockerspec"

# Install docker
RUN set -x \
  && curl -fSL "https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-17.03.1-ce.tgz" -o docker.tgz \
  && echo "820d13b5699b5df63f7032c8517a5f118a44e2be548dd03271a86656a544af55 *docker.tgz" | sha256sum -c - \
  && tar -xzvf docker.tgz \
  && mv docker/* /usr/local/bin/ \
  && rmdir docker \
  && rm docker.tgz \
  && docker -v \
  ;

# Install docker-compose
RUN set -x \
  && apk add --no-cache python2 py2-pip \
  && pip install --upgrade pip \
  && pip install docker-compose \
  && apk del --no-cache py2-pip \
  && docker-compose -v \
  ;

# Install packages needed for running tests
RUN set -x \
  && apk add --no-cache \
      git \
      make \
  		openssh-client \
  ;

# Install rspec
RUN set -x \
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

COPY docker-entrypoint.d /docker-entrypoint.d

CMD ["rspec"]
