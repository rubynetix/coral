#!/usr/bin/env bash

cd ext/

# Create timer module
swig -ruby timer.i
ruby extconf.rb
make
make install