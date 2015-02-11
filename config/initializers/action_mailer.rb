Zumhotface::Application.configure do
  config.action_mailer.perform_deliveries = Settings.mail.enable
  config.action_mailer.default_url_options = { host: Settings.hostname }
  config.action_mailer.asset_host = "http://#{Settings.hostname}"
end
