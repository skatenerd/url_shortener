# pull official base image
FROM ruby:3.0.1-buster

# set work directory
WORKDIR /usr/src/app

# make app files visible during build time
COPY . /usr/src/app/

RUN chmod +x ./wait-for-it.sh

RUN bundle config set --local without 'test'
RUN bundle install

