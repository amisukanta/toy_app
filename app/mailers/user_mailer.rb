class UserMailer < ApplicationMailer
  
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  
  def reset_password
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
