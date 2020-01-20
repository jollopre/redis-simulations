require 'redis'

module RedisSimulations
  class KeyspaceNotifications
    SIGINT = 'SIGINT'.freeze
    SIGTERM = 'SIGTERM'.freeze
    EXPIRED_PATTERN = '__keyevent@0__:expired'.freeze

    class << self
      def do
        create_keys
        signals_handler
        message_before_subscribing_to_expired_keys
        subscribe_to_expired_keys
      end

      private
      
      def create_keys
        redis.set('foo', 'bar', ex: 2)
        redis.set('bar', 'baz', ex: 4)
      end

      def redis
        @redis ||= Redis.new(host: 'redis')
      end

      def signals_handler
        handler = Proc.new { abort "Unsubscribed from #{EXPIRED_PATTERN}" }
        Signal.trap(SIGINT, &handler)
        Signal.trap(SIGTERM, &handler)
      end

      def message_before_subscribing_to_expired_keys
        puts "About to be subscribed to #{EXPIRED_PATTERN}. You can terminate the subscription anytime by sending SIGINT (e.g Ctrl+C)"
      end

      def subscribe_to_expired_keys
        redis.psubscribe(EXPIRED_PATTERN) do |on|
          on.pmessage do |pattern, channel, message|
            puts "pattern: #{pattern}, channel: #{channel}, message: #{message} received"
          end
        end
      end
    end
  end
end

RedisSimulations::KeyspaceNotifications.do
