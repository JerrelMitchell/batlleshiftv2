class ActivationController < ApplicationController
  def update
    user = User.update(params[:id], status: 1)
    session[:user_id] = user.id
    flash[:notice] = "Thank you! Your account is now activated."
    redirect_to dashboard_path
  end
end
