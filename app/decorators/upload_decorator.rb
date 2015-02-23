require 'linguist'
require 'pygments'

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
    lang || (blob? && file.try(:content_type))
  end

  def raw_preview
    pygmentize if lang || object.code?
  end

  def upload_type
    object.class.name.demodulize.downcase
  end

  def name
    nm = if blob?
      file_file_name
    elsif link?
      link
    elsif code?
      code
    end
    return truncate(nm, length: 20, escape: false)+nm[-10..-1] if nm.size >= 35
    nm
  end

  def url
    h.url_for controller: 'uploads', action: 'show', sid: object.sid, host: Settings.hostname
  end

  def pygmentize(opts = nil)
    opts ||=
      { linenos: 'table',
        anchorlinenos: true,
        lineanchors: 'line',
        linespans: 'line'
      }
    raw =
      if object.code?
        code
      elsif object.blob?
        File.read(file.path)
      end
    "<div class='syntax'>#{Pygments.highlight(raw, lexer: lang, options: opts)}</div>".html_safe
  end
end
