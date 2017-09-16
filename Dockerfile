FROM ruby:2.4.2
RUN apt-get update && apt-get -y install cmake

WORKDIR /app
ADD . /app
RUN bundle install
CMD ["rackup", "-o", "0.0.0.0"]
