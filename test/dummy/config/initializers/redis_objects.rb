require 'uri'
require 'redis-objects'
# https://github.com/nateware/redis-objects
# https://github.com/redis/redis-rb


# if (Rails.env == 'development') ||(Rails.env == 'test')
#   redis = URI.parse(Settings.redis_url)
#   Redis::Objects.redis = Redis.new(
#     :host => redis.host,
#     :port => redis.port || 6379,
#     :password => redis.password,
#     :db => redis.path
#   )

# else
#   redis = URI.parse(Settings.redis_url)
#   Redis::Objects.redis = Redis.new(
#     :host => Settings.redis_urlsplit('@')[1].split(':')[0],
#     :port => .split('@')[1].split(':')[1].gsub('/',''),
#     :password => split('@')[0].split(':')[2],
#     :db => redis.path
#   )
# end
unless $redis
  uri = URI.parse("redis://localhost:6379")
  $redis = Redis.current = REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end
