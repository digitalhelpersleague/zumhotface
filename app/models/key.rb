class Key < ActiveRecord::Base

  belongs_to :user

  belongs_to :sibling, class_name: 'Key'


  def self.provider
    ""
  end

end
