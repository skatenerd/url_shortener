# pull official base image
FROM ruby:3.0.1-buster

# set work directory
WORKDIR /usr/src/app

# copy project
COPY ../web /usr/src/app/

RUN bundle install

