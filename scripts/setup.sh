#!/usr/bin/env bash

install_gem() {
    echo "Installing gem $1"
    gem install $1 --quiet --no-document
}

gem update --system
install_gem bundler
install_gem slop

bundler install

# Compile SWIG module
cd "$(dirname "$0")/../lib/timer/ext/"
swig -ruby ctimer.i
ruby extconf.rb
make
make install