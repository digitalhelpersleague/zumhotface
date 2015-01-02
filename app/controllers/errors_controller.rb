class ErrorsController < ActionController::Base

  def error_404
    @error_message = 'Page not found'
    render :error, status: 404
  end

  def error_500
    @error_message = 'Oh snap'
    render :error, status: 500
  end
end
