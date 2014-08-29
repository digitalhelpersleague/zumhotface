class UsersController < ApplicationController

  respond_to :html, :json

  def request_invitation
    if request.post?
      ApplicationMailer.request_invitation(params[:email], params[:about]).deliver
      flash[:notice] = 'Your request was sent to zumhotface team'
    end
  end

end
