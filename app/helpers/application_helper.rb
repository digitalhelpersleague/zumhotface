module ApplicationHelper

  def header_active?(page)
    "active" if page.to_s == params[:controller]
  end

  def render_flash_messages
    s = ''
    flash.each do |k,v|
      message_type = case k.to_s
        when "alert"
          "warning"
        when "notice"
          "success"
        when "error"
          "danger"
        else
          "info"
      end
      s << "<div role='alert' class=\"alert alert-#{message_type} alert-dismissible \"><button type=\"button\" class=\"close\" data-dismiss=\"alert\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button>#{v.to_s}</div>"
    end
    s.html_safe
  end

end
