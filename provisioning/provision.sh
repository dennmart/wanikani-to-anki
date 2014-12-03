#!/usr/bin/env bash

echo "Updating apt..."
sudo apt-get update -y -qq > /dev/null

echo "Installing required libraries for the app..."
sudo apt-get -y -q install ruby-dev > /dev/null

cd /vagrant

echo "Installing bundler..."
su -c "gem install bundler --no-rdoc --no-ri > /dev/null" root

echo "Installing Ruby gems (this may take a while)..."
bundle install --quiet > /dev/null

echo "Starting up WaniKani To Anki..."
rackup -D
