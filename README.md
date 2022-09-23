# WaniKani to Anki Exporter

## ⚠️ Note: This project is no longer maintained

The WaniKani to Anki app is based on the now-deprecated WaniKani API v1 and is no longer maintained. If you're interested in taking over this project and upgrade the application to work with the latest version of WaniKani's API, please send me a message on Twitter ([@dennmart](https://twitter.com/dennmart)).

---

WaniKani to Anki Exporter is a small website that allows you to easily fetch data from your
[WaniKani](https://www.wanikani.com/) account and generate a file that can be imported
into an [Anki](http://ankisrs.net/) deck.

If you have a WaniKani account, you can see the site up and running at http://wanikanitoanki.com.
You will need a WaniKani API key to see all the functionality built in.

## Prerequisites

- Install [Ruby 2.5.3](https://www.ruby-lang.org/en/).
- Install [Bundler](http://bundler.io/) (`gem install bundler`).

## How to run the website

- Install the project's dependencies:

```
bundle install
```

- Run the web server:

```
puma -C config/puma.rb
```

That should be all! If you go to http://localhost:3000 after that, the site should be working.
Currently there's no database required, but that might change in the future.

## Docker

If you have [Docker](https://www.docker.com/) installed in your local environment, use the
included Dockerfile to build a Docker image that will run the WaniKani to Anki Exporter site
on your system for development purposes.

### Without using Docker Compose

- Build the image using the included Dockerfile:

```
$ docker build -t wanikani_to_anki .
```

After building the image you can run a container using the built image:

```
docker run \
  -p 3000:3000 \
  -v $PWD:/app \
  wanikani_to_anki
```

You can go to http://localhost:3000 to see WaniKani to Anki Exporter up and running.

### Using Docker Compose

If you have [Docker Compose](https://docs.docker.com/compose/) installed, you
can simply run `docker-compose up` to build the image and run the container.

## Why did I build this?

I'm both an avid WaniKani user as a Japanese student, as well as an avid Anki user. I wanted to
be able to have a little bit more control about what things from WaniKani I wanted to study, as
well as control other variables like the time intervals, etc. I noticed that other WaniKani users
were looking for something similar, so I decided to share it as a website.

## Submit a pull request!

1. Fork the repo into your own Github account (https://github.com/dennmart/wanikani-to-anki/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`) and make sure your write tests for your new feature!
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. That's it! High fives given upon request :smile_cat:
