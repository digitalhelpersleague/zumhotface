class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :invitable
         # :registerable

  has_many :uploads
  has_many :keys

  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).freeze

  def has_invites?
    invitation_limit and invitation_limit > 0
  end

  def invited_children
    User.where(invited_by_type: "User", invited_by_id: id)    
  end

  def member?
    !guest?
  end

  def guest?
    id.nil?
  end

  def invitation_limit
    member? ? super : 0
  end

  def give_invites(n=3)
    self.invitation_limit = n
  end

  def storage
    Storage.new total: read_attribute(:storage), used: uploads_total_weight
  end

  def update_total_weight(size)
    update_attribute :uploads_total_weight, uploads_total_weight+size
  end

  def rebuild_uploads_total_weight
    update_attribute :uploads_total_weight, uploads.find_each.map{|u| u.size}.reduce(:+).to_i
  end

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex(32)
    end while self.class.exists?(api_key: api_key)
  end
  
end
