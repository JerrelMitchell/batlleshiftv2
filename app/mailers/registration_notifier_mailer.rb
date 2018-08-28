class RegistrationNotifierMailer < ApplicationMailer
  def register(user)
    @user = user
    mail(to: user.email, subject: "Register to Battleshift, #{user.username}!")
  end
end
