require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'redis', '~> 3.2.2'
end

lambda do
  require 'redis'
  require 'securerandom'

  redis = Redis.new(host: ENV.fetch('REDIS_HOST'))
  redis.flushdb

  loop do
    key = SecureRandom.uuid
    p "Adding key: #{key}, result: #{redis.set(key, 'foo')}"
  end
end.call
