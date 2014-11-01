class AccountController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def update
    if permitted_params
      current_user.update_with_password(permitted_params)
      if current_user.errors.any?
        flash[:error] = current_user.errors.messages.map { |k, v| "#{t(k)} #{v.join(', ')}" }.join('<br /> ')
      end
    end
    redirect_to action: :index
  end

  private

  def permitted_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
