#!/bin/bash

docker-compose up -d

docker-compose down --remove-orphans

# rails db:create need to re up and down
docker-compose up -d

docker-compose down --remove-orphans

docker-compose run --rm api bundle exec rails db:create

