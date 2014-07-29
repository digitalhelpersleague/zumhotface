class AttachmentDecorator < ApplicationDecorator
  delegate_all

  decorates :attachment

  def url
    h.url_for controller: 'attachments', action: 'show', sid: object.sid, host: Settings.host
  end

end
