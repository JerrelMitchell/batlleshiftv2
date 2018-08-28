class RegistrationNotifierMailer < ApplicationMailer
  def register(user)
    @url = "https://battleshift-2.herokuapp.com/activation/#{user.id}"
    mail(to: user.email, subject: "Register to Battleshift, #{user.username}!")
  end
end
