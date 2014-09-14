if defined?(Rack::MiniProfiler) && Rails.env.development?
  Rack::MiniProfiler.config.start_hidden = true
end
