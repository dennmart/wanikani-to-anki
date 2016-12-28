FROM ruby:2.3.3
RUN apt-get update && apt-get -y install cmake

WORKDIR /tmp
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install

WORKDIR /app
ADD . /app
CMD ["rackup", "-o", "0.0.0.0"]
