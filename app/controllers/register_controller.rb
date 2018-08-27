class RegisterController < ApplicationController
  def index

  end

  def create
    user = User.create(register_params)
    session[:user_id] = user.id
    redirect_to '/dashboard'
  end

  private

  def register_params
    params.permit(:email, :username, :password)
  end
end
