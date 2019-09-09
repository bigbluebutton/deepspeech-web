require 'yaml'


if ENV['REDIS_URL'].nil?
  redis = Redis.new
else
  redis = Redis.new(url: ENV['REDIS_URL'])
end

props = YAML::load(File.open('settings.yaml'))
redis_namespace = props["redis_list_namespace"]

# Namespace our keys to bbb_texttrack_service:<whatever>
# $redis.lpush("foo", "bar") is really bbb_texttrack_service:foo
# $redis.llen("foo") is really bbb_texttrack_service:foo
$redis = Redis::Namespace.new(redis_namespace, :redis => Redis.new)
