require 'hashie'

unless defined?(Settings)

  app_root = defined?(Rails) ? Rails.root : File.expand_path('../../..', __FILE__)
  app_env = defined?(Rails) ? Rails.env : ENV['RAILS_ENV'] || ENV['RACK_ENV']

  settings_path = File.join(app_root, 'config', 'settings.yml')
  local_settings_path = File.join(app_root, 'config', 'settings.local.yml')

  Settings = Hashie::Mash.load(settings_path)[app_env]

  if File.exists? local_settings_path
    local_settings = Hashie::Mash.load(local_settings_path)[app_env]
    Settings.merge!(local_settings) if local_settings && local_settings.any?
  end

end
