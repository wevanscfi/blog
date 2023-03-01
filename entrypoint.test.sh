#!/bin/usr/env bash
export RAILS_ENV="test"
bundle exec rspec

/opt/cc-test-reporter format-coverage -t simplecov coverage/.resultset.json

