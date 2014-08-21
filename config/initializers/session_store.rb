# Be sure to restart your server when you modify this file.

Zumhotface::Application.config.session_store :redis_store, servers: { namespace: 'zhf:sessions' }
