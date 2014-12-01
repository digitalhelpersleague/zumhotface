require File.expand_path('../boot', __FILE__)

require 'rails/all'

# require Settings
require './config/initializers/_settings'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zumhotface
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'api')

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.assets.initialize_on_precompile = false

    config.action_mailer.default_url_options = { host: ENV['ZHF_HOST'] || 'localhost' }
    config.action_mailer.asset_host = "http://#{ENV['ZHF_HOST'] || 'localhost'}"

    config.middleware.use Rack::ContentLength

    config.cache_store = :redis_store, { namespace: 'zhf:cache', expires_in: 90.minutes }
  end
end
