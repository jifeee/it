#!/bin/sh

RAILS_ENV=production script/delayed_job stop
git reset --hard
git pull origin master
bundle install
RAILS_ENV=production rake db:migrate
kill -9 `cat tmp/pids/unicorn.pid`
sleep 5
kill -9 `cat tmp/pids/unicorn.pid`
sleep 2
RAILS_ENV=production bundle exec unicorn_rails -o 127.0.0.1 -c config/unicorn.rb -E production -D
sleep 4
RAILS_ENV=production script/delayed_job start

echo "Instatrace deployment done"

