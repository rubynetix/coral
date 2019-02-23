#!/usr/bin/env bash

cd ext/

# Create timer module
swig -ruby ctimer.i
ruby extconf.rb
make
make install