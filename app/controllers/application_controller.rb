class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :include_current_user

private
  def include_current_user
    if request.format.html?
      @user = UserDecorator.decorate(current_user)
      gon.rabl template: "app/views/users/show.json.rabl", as: :current_user
    end
  end

protected
  def current_user
    super || User.new
  end
end
