# frozen_string_literal: true

require 'yaml'

redis = if ENV['REDIS_URL'].nil?
          Redis.new
        else
          Redis.new(url: ENV['REDIS_URL'])
        end

props = YAML.load(File.open('settings.yaml'))
redis_namespace = props['redis_list_namespace']

# Namespace our keys to bbb_texttrack_service:<whatever>
# $redis.lpush("foo", "bar") is really bbb_texttrack_service:foo
# $redis.llen("foo") is really bbb_texttrack_service:foo
# rubocop:disable Style/GlobalVars
$redis = Redis::Namespace.new(redis_namespace, redis: Redis.new)
# rubocop:enable Style/GlobalVars
