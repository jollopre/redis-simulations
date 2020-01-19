require 'redis'
require 'securerandom'

module RedisSimulations
  class OutOfMemory
    class << self
      def do
        loop do
          create_key_randomly
        end
      rescue Redis::CommandError => e
        abort(e.message)
      end

      private

      def create_key_randomly
        key = SecureRandom.uuid
        puts "Adding key: #{key}, result: #{redis.set(key, 'foo')}"
      end

      def redis
        @redis ||= Redis.new(host: 'redis')
      end
    end
  end
end

RedisSimulations::OutOfMemory.do
