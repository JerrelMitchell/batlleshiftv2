class ActivationController < ApplicationController
  def update
    User.update(params[:id], status: 1)
    flash[:notice] = "Thank you! Your account is now activated."
    redirect_to dashboard_path
  end
end
