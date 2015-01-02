module Encryptable
  extend ActiveSupport::Concern

  def encrypted?
    false
  end
end
