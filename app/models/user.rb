class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  has_many :uploads

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

private
  def give_invites(n=3)
    self.invitation_limit = n
  end

end
