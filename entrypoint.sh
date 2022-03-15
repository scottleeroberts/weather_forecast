#!/bin/bash

rm -f /usr/src/app/tmp/pids/server.pid

bundle check || bundle install -j8

bundle exec puma -C config/puma.rb
