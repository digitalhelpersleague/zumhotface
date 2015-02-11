Zumhotface::Application.configure do
  redis_config = {
    host:       Settings.redis.host,
    port:       Settings.redis.port,
    db:         Settings.redis.database,
    expires_in: 90.minutes }

  config.cache_store = :redis_store, redis_config.merge(
    namespace:  "#{Settings.redis.namespace}:cache"
  )

  config.session_store :redis_store, servers: redis_config.merge(
    namespace:  "#{Settings.redis.namespace}:sessions"
  )
end
