# pull official base image
FROM ruby:3.0.1-buster

# set work directory
WORKDIR /usr/src/app

# make app files visible during build time
COPY . /usr/src/app/

RUN bundle install

