FROM ubuntu:16.04

MAINTAINER luksi1

ENV DEBIAN_FRONTEND=noninteractive \
    # Gosu version. Gosu is used to run applications using a specific user.
    GOSU_VERSION=1.9

# Install gosuENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget tzdata locales nscd git ssh curl gcc libcurl4-openssl-dev make build-essential \
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
RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
RUN dpkg -i puppetlabs-release-pc1-xenial.deb

# Puppet needs UID/GID 999 as this is used as standard
# in puppet-in-docker containers
RUN groupadd -g 999 puppet
RUN useradd -ms /bin/bash -g puppet -u 999 puppet

# ensure that upstart is booting correctly in the container
#RUN rm /usr/sbin/policy-rc.d && rm /sbin/initctl && dpkg-divert --rename --remove /sbin/initctl 
RUN apt-get update && apt-get install -y net-tools wget puppet-agent && locale-gen en_US.UTF-8

# r10k: use this to pull our control repo in-case we're testing a profile
# hiera-eyaml: use this to test hiera eyaml files. this is needed to test certain profiles that use this feature
# curb: a nice way to run acceptance tests against external resources, when testing infrastructure changes
RUN /opt/puppetlabs/puppet/bin/gem install r10k hiera-eyaml curb

# I've had a few problems with symlinks to facter and puppet not getting created correctly.
RUN ln -s /opt/puppetlabs/bin/facter /usr/bin/facter
RUN ln -s /opt/puppetlabs/bin/puppet /usr/bin/puppet

