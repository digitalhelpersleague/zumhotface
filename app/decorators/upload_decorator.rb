require 'linguist'

class UploadDecorator < ApplicationDecorator
  delegate_all

  decorates :upload

  def icon
    case upload_type
    when 'file'
      'paperclip'
    when 'code'
      'file'
    when 'link'
      'link'
    end
  end

  def content_type
    lang || file.try(:content_type)
  end

  def code_preview
    return unless lang
    return ("<div class='syntax'>" + Linguist::FileBlob.new(file.path).colorize + '</div>').html_safe if file?
    return ("<div class='syntax'>" + Linguist::Language.new(name: lang).colorize(code) + '</div>').html_safe if code?
  end

  def upload_type
    object.class.upload_type
  end

  def name
    file_file_name || link || code
  end

  def url
    h.url_for controller: 'uploads', action: 'show', sid: object.sid, host: Settings.host
  end
end
