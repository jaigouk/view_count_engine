require 'uri'
require 'redis-objects'
# https://github.com/nateware/redis-objects
# https://github.com/redis/redis-rb

if Rails.env.development?
	unless Redis.current
	  uri = URI.parse("redis://localhost:6379")
	  REDIS = Redis.current = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	end
else
	unless Redis.current
	  uri = URI.parse(Settings.redis_url)
	  REDIS = Redis.current = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	end
end
