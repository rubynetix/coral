#!/usr/bin/env bash

gem update --system
gem install bundler
gem install slop

bundler install
