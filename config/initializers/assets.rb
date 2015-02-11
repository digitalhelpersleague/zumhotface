Zumhotface::Application.configure do
  config.assets.initialize_on_precompile = false
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
end
