class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
         # :registerable,

  has_many :uploads
  has_many :keys

  SAFE_CHARS = (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).freeze

  before_validation :set_unique_identifier

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

private
  def set_unique_identifier
    unless self.sid
      begin
          self.sid = generate_identifier
      end while self.class.exists?(sid: self.sid)
    end
  end

  def generate_identifier
    # limit to 916132832 unique combinations
    # so we should increase chars count later
    Array.new(5){ SAFE_CHARS.sample }.join
  end

end
