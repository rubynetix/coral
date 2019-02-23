#!/usr/bin/env bash

# Remove compiled SWIG extension
cd "$(dirname "$0")/../lib/timer/"
rm ctimer_wrap.c Makefile *.so *.o .sitearchdir.time