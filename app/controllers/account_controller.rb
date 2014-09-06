class AccountController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def update
    if params[:user]
      current_user.update_with_password(permitted_params[:user])
      flash[:error] = current_user.errors.messages.map { |k, v| "#{t(k)} #{v.join(', ')}" }.join('<br /> ') if current_user.errors.any?
    end
    redirect_to action: :index
  end

  private

  def permitted_params
    params.permit(user: [:password, :password_confirmation, :current_password])
  end
end
