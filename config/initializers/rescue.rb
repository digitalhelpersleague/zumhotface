require 'resque'

Resque.redis = KV

Resque.after_fork do
  ActiveRecord::Base.establish_connection
  Resque.redis.client.reconnect
end
