class UsersController < ApplicationController
  respond_to :html, :json

  def request_invitation
    return unless request.post?
    ApplicationMailer.request_invitation(params[:email], params[:about]).deliver
    flash[:notice] = 'Your request was sent to zumhotface team'
  end

  def generate_api_key
    current_user.generate_api_key
    if current_user.save!
      render(json: { success: true, api_key: current_user.api_key }) && return
    end
  end

  def destroy_api_key
    current_user.api_key = nil
    if current_user.save!
      render(json: { success: true, api_key: current_user.api_key }) && return
    end
  end
end
