class UsersController < ApplicationController
  before_filter :retrieve_users, :only => :index
  load_resource
  
  def index
    @search = User.new(params[:user])
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def create
    user = User.new params[:user]
    render :new and return unless user.valid?     
    some_company = Company.find(params[:company_id]) unless params[:company_id].nil?    
    some_company = Agent.find(params[:agent_id]) unless params[:agent_id].nil?
    some_company.users << user
    redirect_to some_company
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation) 
    end
    if @user.update_attributes params[:user]
      some_company = Company.find(params[:company_id]) unless params[:company_id].blank?    
      some_company = Agent.find(params[:agent_id]) unless params[:agent_id].blank?
      Mailer.user_updated(@user).deliver if params[:notify] == 'true'
      redirect_to some_company
    else
      render :edit
    end
  end
  
  def batch_delete
    User.destroy_all(:id => params[:ids].split(','))
    redirect_to request.referrer || companies_path
  end
  
protected

  def retrieve_users
  	params[:role] = 'freight_forwarders' unless Role::ROLES.include? params[:role].try(:singularize)
    @users = User.send(params[:role]).page(params[:page]).per(20)
  end

end
