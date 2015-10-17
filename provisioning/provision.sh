#!/usr/bin/env bash
echo "Updating apt..."
sudo apt-get update -y -qq

echo "Installing required libraries for Ruby..."
sudo apt-get -y -qq install build-essential git libssl-dev libreadline-dev zlib1g-dev

echo "Setting up rbenv..."
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

echo "Installing Ruby 2.2.3 (this may take a while)..."
rbenv install 2.2.3
rbenv global 2.2.3

echo "Installing bundler..."
gem install bundler --no-rdoc --no-ri

echo "Installing Ruby gems (this may take a while)..."
cd /vagrant
bundle install

echo "Starting up WaniKani To Anki..."
rackup -D -o 0.0.0.0

echo "Done! You should be able to access WaniKani to Anki at http://localhost:9393. Enjoy!"
