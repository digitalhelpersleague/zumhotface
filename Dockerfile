FROM debian:jessie
MAINTAINER kr3ssh@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Setup build dependencies
RUN apt-get update \
  && apt-get install -y nginx nodejs \
    autoconf bison libreadline6-dev zlib1g zlib1g-dev \
    build-essential libssl-dev libpq-dev libyaml-dev \
    git curl wget libxml2-dev libxslt1-dev \
  && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
  && locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales

# Fix for some nodejs packages hardcoded to node executable
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Stop nginx server
RUN /etc/init.d/nginx stop

RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/rbenv/plugins/ruby-build
RUN /opt/rbenv/plugins/ruby-build/install.sh
ENV PATH /opt/rbenv/bin:/opt/rbenv/shims:$PATH

RUN echo 'export PATH=$HOME/.rbenv/bin:$HOME/.rbenv/shims:/opt/rbenv/bin:/opt/rbenv/shims:$PATH' >> /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile

WORKDIR /opt/zumhotface

RUN rbenv install \
  && gem install --no-document bundler \
  && rbenv rehash \
  && bundle install --deployment --without development test
  && ZHF_SECRET_KEY=not_so_secret_key_just_for_assets_precompilation RAILS_ENV=production bundle exec rake assets:precompile

# Purge build dependencies
RUN apt-get purge -y --auto-remove gcc g++ make patch pkg-config cmake \
  libc6-dev libpq-dev zlib1g-dev libyaml-dev libssl-dev \
  libgdbm-dev libreadline6-dev libxml2-dev libxslt-dev \
  && apt-get clean

EXPOSE 80
EXPOSE 443

VOLUME /data
VOLUME /opt/zumhotface

CMD nginx && foreman start
