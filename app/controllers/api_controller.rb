class ApiController < ActionController::API
  include ActionController::Helpers
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers.env['HTTP_X_API_KEY'])
  end
end
