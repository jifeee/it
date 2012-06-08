class Api::ApiController < ApplicationController
  before_filter :get_session, :except => :activation
  
  def activation
    user = User.find_by_activation_code params[:code] unless params[:code].blank?
    if user
      user.generate_token!
      render :json => {:token => user.api_token}
    else
      render :status => 403, :json => { :errors => "Not Authorized" } and return
    end
  end
  
  protected
  def get_session
    @user = User.find_by_api_token params[:token] unless params[:token].blank?
    if @user
      sign_in :user, @user
    else
      render :status => 403, :json => { :errors => "Not Authorized" } and return
    end
  end
end
