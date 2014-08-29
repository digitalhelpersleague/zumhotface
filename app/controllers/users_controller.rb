class UsersController < ApplicationController

  respond_to :html, :json

  def request_invitation
    if request.post?
      ApplicationMailer.request_invitation(params[:email], params[:about]).deliver
      flash[:notice] = 'Your request was sent to zumhotface team'
    end
  end

  def generate_api_key
    current_user.generate_api_key
    if current_user.save!
      render json: {success: true, api_key: current_user.api_key} and return
    end
  end

  def destroy_api_key
    current_user.api_key = nil
    if current_user.save!
      render json: {success: true, api_key: current_user.api_key} and return
    end
  end


end
