class ApplicationController < ActionController::Base
  protect_from_forgery
 
  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end
 
  protected
  # restrict access to admin module for non-admin users
  def authenticate_admin_user
    raise CanCan::AccessDenied unless current_user && current_user.manager?
  end
  
  # path for redirection after user sign_in, depending on user role
  def after_sign_in_path_for(user)
  	user.admin? ? admin_dashboard_path : root_path
  end
end

