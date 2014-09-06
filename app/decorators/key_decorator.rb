class KeyDecorator < ApplicationDecorator
  delegate_all

  decorates :key

  def provider
    object.class.provider
  end
end
