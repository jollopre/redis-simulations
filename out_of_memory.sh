#!/bin/bash

# Runs a container with at maximum 4 megabytes of memory (without swap) whose main process is redis using at maximum 1mb of memory to store keys
redis_id=$(docker run --rm -d -p 6379:6379 -m 4m --memory-swap 4m redis:5.0.5 redis-server --loglevel debug --maxmemory 1mb)

# Runs a container with to run oom.rb ruby file using redis server container to persist
docker run --rm -it --link $redis_id -v "$PWD":/usr/src -w /usr/src --env REDIS_HOST=$redis_id ruby:2.6.3 ruby out_of_memory.rb

# Stops redis server afterwards
docker stop $redis_id
