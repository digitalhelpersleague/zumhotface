KV = Redis::Namespace.new(
  Settings.redis.namespace,
  redis: Redis.new(
    url: "redis://#{Settings.redis.host}:#{Settings.redis.port}/#{Settings.redis.database}"
  )
)
