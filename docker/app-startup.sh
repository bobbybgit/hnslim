#!/bin/bash

if bundle exec rails db:exists ; then
    echo 'Running database migrations...'
    bundle exec rails db:migrate
else
    echo 'Creating and seeding application database...'
    bundle exec rails db:create
    bundle exec rails db:migrate
    bundle exec rails db:seed
fi