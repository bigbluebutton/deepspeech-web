# frozen_string_literal: true

require 'yaml'

props = YAML.safe_load(File.open('settings.yaml'))
redis_namespace = props['redis_list_namespace']

# Namespace our keys to bbb_texttrack_service:<whatever>
# $redis.lpush("foo", "bar") is really bbb_texttrack_service:foo
# $redis.llen("foo") is really bbb_texttrack_service:foo
# rubocop:disable Style/GlobalVars
$redis = Redis::Namespace.new(redis_namespace, redis: Redis.new)
# rubocop:enable Style/GlobalVars
