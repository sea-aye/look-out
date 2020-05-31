#!/usr/bin/env bash

# Load RVM
source "${HOME}/.rvm/scripts/rvm"

# Start postgres
# pg_ctl -D db/pg_data start

bundle install

bundle exec rspec
