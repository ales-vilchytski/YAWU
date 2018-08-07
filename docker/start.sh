#!/bin/sh

rm -r /usr/src/app/tmp/pids

/opt/jruby/bin/jruby -S rails server
