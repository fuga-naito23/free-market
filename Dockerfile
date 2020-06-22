FROM ruby:2.7.0

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src

WORKDIR $APP_ROOT

RUN set -ex && \
    apt-get update -qq && \
    apt-get install -y sudo && \
    : "Install node.js" && \
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs && \
    : "Install yarn" && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y yarn && \
    : "Install rails6.X latest version" && \
    gem install rails --version="~>6.0.0"
ADD Gemfile $APP_ROOT/Gemfile
ADD Gemfile.lock $APP_ROOT/Gemfile.lock
RUN gem install bundler:1.17.2 &&\
    bundle install &&\
    yarn install --check-files &&\
    rails db:create && \
    rails db:migrate && \
    rails db:seed
# MEMO: docker exec -it rails_web /bin/bash
# MEMO: ./config/database.ymlを password: root, host: db に書き換え

