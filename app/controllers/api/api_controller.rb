class Api::ApiController < ApplicationController
  before_filter :get_session
  
  def activation
    render :status => 200, :nothing => true
  end
  
  protected
  def get_session
    @user = User.find_by_api_token params[:code] unless params[:code].blank?
    if @user
      sign_in :user, @user
    else
      render :status => 403, :json => { :errors => "Not Authorized" } and return
    end
  end
end
