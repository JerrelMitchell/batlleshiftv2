class ActivationController < ApplicationController
  def update
    user = User.find_by(activation_token: params[:activation_token])
    user.update(status: 1)
    session[:user_id] = user.id
    flash[:notice] = "Thank you! Your account is now activated."
    redirect_to dashboard_path
  end
end
