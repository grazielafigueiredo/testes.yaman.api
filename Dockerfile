# Build without alpine because problems with lib.
FROM ubuntu:18.04

# Base Dependencies
RUN apt-get update --fix-missing
RUN apt-get install -y build-essential
RUN apt-get install -y software-properties-common

# Ruby Dependencies
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y ruby2.6 ruby2.6-dev
RUN gem install bundler

# Step to cache dependencies in docker

WORKDIR /app

COPY Gemfile /app/Gemfile

COPY . /app

RUN bundle install

CMD ["cucumber"]