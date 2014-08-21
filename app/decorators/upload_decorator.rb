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
    if lang and file?
      return ("<div class='syntax'>"+Linguist::FileBlob.new(file.path).colorize+"</div>").html_safe
    end
  end

  def upload_type
    object.class.upload_type
  end

  def name
    file_file_name || link || text
  end

  def url
    h.url_for controller: 'uploads', action: 'show', sid: object.sid, host: Settings.host
  end

end
