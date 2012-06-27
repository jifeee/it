# Uncomment if need manual test I18n
# module I18n; def self.t(id); '~'; end; end

class ApplicationController < ActionController::Base
  APPLICATION_VERSION = '1.0.12'

  protect_from_forgery

  before_filter :locale
  helper_method :current_locale, :application_version
 
  rescue_from CanCan::AccessDenied do
    flash[:notice] = 'Access denied'
    redirect_to root_path
  end

  def default_url_options(options={})
    {:locale => I18n.locale}
  end

  def set_locale
    cookies["language"] = params[:language]
    redirect_to root_path(:locale => params[:language])
  end

  def reflatten(hash,key=nil)
    (key.nil? ? hash : hash[key]).map {|k,v| (v.class == Hash ? reflatten(v) : {k => v})}
  end

  def check_locale
    r = []
    default_locale = YAML::load(File.open(File.join(Rails.root,'config','locales',"#{I18n.default_locale}.yml")))
    d = reflatten(default_locale).flatten
    d_keys = d.map{|a| a.keys}
    I18n::available_locales.map do |locale|
      next if locale == I18n.default_locale
      l = YAML::load(File.open(File.join(Rails.root,'config','locales',"#{locale}.yml")))
      dd = reflatten(l).flatten
      dd_keys = dd.map{|a| a.keys}
      r << d_keys - dd_keys
    end
    r.flatten!
    @res = d.select {|a| r.include?(a.keys.first.to_s)}
  end

protected

  def application_version
    APPLICATION_VERSION || '0.0.9'
  end

  def locale
    I18n.locale = current_locale
  end

  def current_locale
    return params[:locale] if params[:locale]
    return cookies["language"] unless cookies["language"].nil?
    return current_user.language
    return extract_locale_from_accept_language_header || i18n.default_locale
  rescue 
    I18n.default_locale || 'en'
  end

  def extract_locale_from_accept_language_header
     request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first    
  end

  # restrict access to admin module for non-admin users
  def authenticate_admin_user
    flash[:notice] = 'Only for logged users'
    raise CanCan::AccessDenied unless current_user && current_user.manager?
  end
  
  # path for redirection after user sign_in, depending on user role
  def after_sign_in_path_for(user)
  	user.sa? ? admin_dashboard_path : root_path
  end
end

