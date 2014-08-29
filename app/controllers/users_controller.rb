class UsersController < ApplicationController

  respond_to :html, :json
  inherit_resources

  def request_invitation
    if request.post?
      ApplicationMailer.request_invitation(params[:email], params[:about]).deliver
      flash[:success] = 'ok'
      redirect_to root_path
    end
  end

end
