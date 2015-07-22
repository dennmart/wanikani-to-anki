#!/usr/bin/env bash

echo "Updating apt..."
sudo apt-get update -y -qq

echo "Installing required libraries for the app..."
sudo apt-get -y -q install build-essential ruby-dev zlib1g-dev

cd /vagrant

echo "Installing bundler..."
su -c "gem install bundler --no-rdoc --no-ri" root

echo "Installing Ruby gems (this may take a while)..."
bundle install

echo "Starting up WaniKani To Anki..."
rackup -D -o 0.0.0.0
