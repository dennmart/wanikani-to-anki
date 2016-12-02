FROM ruby:2.3.3
ADD . /app
WORKDIR /app
RUN apt-get update && apt-get -y install cmake && bundle install
CMD rackup -o 0.0.0.0
