class Mailer < ActionMailer::Base
  default :from => "no-reply@instatrace.com"
  
  def user_created(user)
    @user, @pwd = user, user.password
    mail(:to => user.email, :subject => "Your account was registered at instatrace.com")   
  end

  def user_updated(user)
    @user, @pwd = user, user.password
    mail(:to => user.email, :subject => "Your account was updated at instatrace.com")   
  end
end
