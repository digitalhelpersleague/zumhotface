class UsersController < ApplicationController
  respond_to :html, :json

  def request_invitation
    return unless request.post?
    ApplicationMailer.request_invitation(params[:email], params[:about]).deliver_later
    flash[:notice] = 'Your request was sent to zumhotface team'
  end

  def generate_api_key
    current_user.generate_api_key! &&
      render(json: { success: true, api_key: current_user.api_key })
  end

  def destroy_api_key
    current_user.destroy_api_key! &&
      render(nothing: true, status: 204)
  end
end
