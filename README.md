# WaniKani to Anki Exporter

#### Get your WaniKani decks in Anki!

WaniKani to Anki Exporter is a small website that allows you to easily fetch data from your
[WaniKani](https://www.wanikani.com/) account and generate a file that can be imported
into an [Anki](http://ankisrs.net/) deck.

If you have a WaniKani account, you can see the site up and running at http://wanikanitoanki.com.
You will need a WaniKani API key to see all the functionality built in.

## Prerequisites

1. Ruby 2.2.0 https://www.ruby-lang.org/en/

Install as per your operating system instructions.

2. Bundler http://bundler.io/

```
gem install bundler
```

## How to run the website

The WaniKani to Anki Exporter site is a [Padrino](http://www.padrinorb.com/) app.

Getting the site up and running is very simple.
In the project's directory, run the following:

```
$ bundle install
$ rackup
```

That should be all! If you go to http://localhost:9292 after that, the site should be working.
Currently there's no database required, but that might change in the future as I expand the
site's functionality.

## Vagrant

If you have [Vagrant](https://www.vagrantup.com/) installed, I included a simple Vagrantfile that will set up an environment
and automatically run the WaniKani to Anki Exporter site in an Ubuntu 14.04 virtual machine on
your local machine. By simply running `vagrant up`, you should be able to go to http://localhost:9292
and see the site.

By default, the provisioning is done using a [shell script](https://github.com/dennmart/wanikani-to-anki/blob/master/provisioning/provision.sh)
that I have included in the repository. If you prefer to use [Ansible](http://www.ansible.com/home) as
your primary automation tool, I also included an [Ansible playbook](https://github.com/dennmart/wanikani-to-anki/blob/master/provisioning/playbook.yml)
that you can use instead. You will have to modify the Vagrantfile to use Ansible instead.

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
