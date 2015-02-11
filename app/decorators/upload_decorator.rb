require 'linguist'

class UploadDecorator < ApplicationDecorator
  delegate_all
  decorates :upload

  def icon
    case upload_type
    when 'blob'
      'paperclip'
    when 'code'
      'file'
    else
      upload_type
    end
  end

  def content_type
    lang || file.try(:content_type)
  end

  def raw_preview
    if lang
      return ("<div class='syntax'>" + Linguist::FileBlob.new(file.path).colorize + '</div>').html_safe if object.blob?
      return (
              "<div class='syntax'>" +
                Linguist::Language.new(name: lang).colorize(code) +
              '</div>'
             ).html_safe if object.code
    end
    return ("<div class='syntax'><pre>" + code + '</pre></div>').html_safe if object.code?
  end

  def upload_type
    object.class.name.demodulize.downcase
  end

  def name
    file_file_name || link || code
  end

  def url
    h.url_for controller: 'uploads', action: 'show', sid: object.sid, host: Settings.hostname
  end
end
