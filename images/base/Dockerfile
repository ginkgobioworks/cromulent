FROM ubuntu:14.04
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
ENV DEBIAN_FRONTEND noninteractive

# arvados
ADD apt.arvados.org.list /etc/apt/sources.list.d/
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7
RUN apt-get update -q

RUN apt-get update && apt-get install -qy \
    build-essential \
    libreadline6-dev zlib1g-dev libssl-dev \
    libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev \
    libncurses5-dev automake libtool bison pkg-config libffi-dev curl postgresql-client \
    gawk libgmp-dev

# RVM
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys D39DC0E3 && \
    curl -L https://get.rvm.io | bash -s stable && \
    /usr/local/rvm/bin/rvm install 2.1 && \
    /usr/local/rvm/bin/rvm alias create default ruby-2.1 && \
    echo "source /usr/local/rvm/scripts/rvm" >> /etc/profile && \
    /usr/local/rvm/bin/rvm all do gem install bundler

RUN mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.7.tar.gz | tar xz && \
    cd ruby-2.1.7 && \
    ./configure --disable-install-rdoc && \
    make -j8 && \
    make install && \
    sudo -i gem install bundler

# copy tools over
COPY wait-for-it.sh /usr/bin/wait-for-it
COPY etc_arvados/ /etc/arvados
