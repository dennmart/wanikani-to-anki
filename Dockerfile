FROM ruby:2.3.2
ADD . /app
WORKDIR /app
EXPOSE 9292
RUN apt-get update && apt-get -y install cmake && bundle install
CMD rackup -o 0.0.0.0
