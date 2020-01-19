FROM ruby:2.6.3

ENV APP /usr/src

WORKDIR $APP

COPY Gemfile $APP/

RUN bundle install -j 10
