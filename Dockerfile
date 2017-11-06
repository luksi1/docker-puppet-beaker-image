FROM ubuntu:14.04

MAINTAINER luksi1

ENV DEBIAN_FRONTEND=noninteractive \
    # Gosu version. Gosu is used to run applications using a specific user.
    GOSU_VERSION=1.9

# Install gosuENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget tzdata locales nscd \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Enable Puppet repo
RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
RUN dpkg -i puppetlabs-release-pc1-trusty.deb

# Puppet needs UID/GID 999 as this is used as standard
# in puppet-in-docker containers
RUN groupadd -g 999 puppet
RUN useradd -ms /bin/bash -g puppet -u 999 puppet

RUN apt-get update \
  && apt-get install -y puppet-agent 

#COPY docker-entrypoint.sh /
#RUN chmod +x /docker-entrypoint.sh

#CMD /docker-entrypoint.sh
