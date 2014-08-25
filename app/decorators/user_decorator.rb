class UserDecorator < ApplicationDecorator
  delegate_all

  decorates :user

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def storage_percent_used
    (object.storage.used.to_f / object.storage.total * 100).round(1)
  end

  def storage_used
    object.storage.used
  end

  def storage_total
    object.storage.total
  end

end
