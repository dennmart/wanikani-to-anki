FROM ruby:2.5.1-slim
RUN apt-get update && apt-get -y install cmake

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install

COPY . /app/
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
