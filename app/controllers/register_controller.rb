class RegisterController < ApplicationController
  def index

  end

  def create
    User.create(register_params)
    redirect_to '/dashboard'
  end

  private

  def register_params
    params.permit(:email, :username, :password)
  end
end
