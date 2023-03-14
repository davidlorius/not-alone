#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

cd /app && bundle exec rails s -b 0.0.0.0