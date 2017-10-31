FROM ruby:2.2-alpine
MAINTAINER Franco Leonardo Bulgarelli

RUN apk add --no-cache build-base

RUN gem install minitest --version '=5.9.0'
RUN gem install activesupport --version '=4.1.0'
RUN gem install mumukit --version '=2.4.0'
COPY multitest.rb multitest.rb
