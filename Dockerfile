FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y ruby2.6 ruby2.6-dev freetds-bin freetds-dev
RUN gem install bundler

RUN apt-get install -y wget gcc make && \
  wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.92.tar.gz && \
  tar -xzf freetds-1.00.92.tar.gz && \
  cd freetds-1.00.92 && \
  ./configure --prefix=/home/deploy/tds && \
  make && make install && make clean

COPY . /data

WORKDIR /data/back_lottocap

RUN bundle install