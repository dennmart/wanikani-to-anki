FROM ruby:2.4.1
RUN apt-get update && apt-get -y install cmake

WORKDIR /tmp
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

WORKDIR /app
ADD . /app
CMD ["rackup", "-o", "0.0.0.0"]
