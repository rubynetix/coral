#!/usr/bin/env bash

install_gem() {
    echo "Installing gem $1"
    gem install $1 --quiet --no-document
}

gem update --system
install_gem bundler
bundle install
