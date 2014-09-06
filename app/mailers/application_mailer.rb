class ApplicationMailer < ActionMailer::Base
  default from: "#{Rails.application.class.parent_name} <#{Settings.mail.from}>"

  def request_invitation(email, body)
    @email = email
    @body  = body
    mail to: Settings.mail.admin, subject: '[zhf.io] New invitation request'
  end
end
