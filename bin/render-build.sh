#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
# Add to render-build.sh
bundle exec rails runner "ActiveRecord::Base.connection.execute('SELECT 1')"
