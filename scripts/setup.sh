#!/usr/bin/env bash

install_gem() {
    echo "Installing gem $1"
    gem install $1 --quiet --no-document
}

gem update --system
install_gem bundler
bundle install

# Install SWIG
sudo apt-get update
sudo apt-get install -y swig

# Compile SWIG module
cd "$(dirname "$0")/../lib/timer/"
swig -ruby ctimer.i
ruby extconf.rb
make
make install
