class AccountController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :json

  def index
  end

  def update
    current_user.update_with_password(permitted_params)
    respond_with current_user, location: -> { account_path }
  end

  private

  def permitted_params
    params.require(:user).permit(
      :password, :password_confirmation, :current_password
    )
  end
end
