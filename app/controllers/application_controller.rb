class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  self.responder = ApplicationResponder
  helper_method :current_user
  before_action :include_current_user

  private

  def include_current_user
    return unless request.format.html?
    @user = UserDecorator.decorate(current_user)
    gon.rabl template: 'app/views/users/show.json.rabl', as: :current_user
  end

  protected

  def current_user
    super || User.new
  end
end
