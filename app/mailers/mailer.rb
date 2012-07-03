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

  def damage_notifier(milestone)
  	@shipment = milestone.shipment
  	subject = "Shimpent #{@shipment.shipment_id} was damaged"
  	milestone.driver.user_relations.first.owner.users.operators do |operator|
    	mail(:to => operator.email, :subject => subject)
  	end
  end

  def send_milestone_signature(milestone)
    @milestone = milestone
    subject = "Milestone's signature for shipment #{milestone.shipment.hawb}" 
    mail(:to => milestone.signature.email, :subject => subject) if milestone.signature.email
  end
end
