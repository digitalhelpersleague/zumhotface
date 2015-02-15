Zumhotface::Application.configure do
  config.action_mailer.perform_deliveries = Settings.mail.enable
  config.action_mailer.default_url_options = { host: Settings.hostname }
  config.action_mailer.asset_host = "http://#{Settings.hostname}"

  if Settings.mail.enable
    case Rails.env
    when 'production'
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        address:              Settings.mail.smtp.host,
        port:                 Settings.mail.smtp.port,
        user_name:            Settings.mail.smtp.login,
        password:             Settings.mail.smtp.password,
        authentication:       Settings.mail.smtp.authentication,
        enable_starttls_auto: Settings.mail.smtp.starttls,
        tls:                  Settings.mail.smtp.tls
      }
    when 'development'
      config.action_mailer.delivery_method = :letter_opener
    end
  end
end
