class UserDecorator < ApplicationDecorator
  delegate_all
  decorates :user

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
