class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :locale
  helper_method :current_locale
 
  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end

  def default_url_options(options={})
    {:locale => I18n.locale}
  end

  def set_locale
    cookies["language"] = params[:language]
    redirect_to root_path(:locale => params[:language])
  end

  protected

  def locale
    I18n.locale = current_locale
  end

  def current_locale
    return params[:locale] if params[:locale]
    return cookies["language"] unless cookies["language"].nil?
    return extract_locale_from_accept_language_header || i18n.default_locale
  rescue 
    i18n.default_locale || 'en'
  end

  def extract_locale_from_accept_language_header
     request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first    
  end

  # restrict access to admin module for non-admin users
  def authenticate_admin_user
    raise CanCan::AccessDenied unless current_user && current_user.manager?
  end
  
  # path for redirection after user sign_in, depending on user role
  def after_sign_in_path_for(user)
  	user.admin? ? admin_dashboard_path : root_path
  end
end

