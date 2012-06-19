class UsersController < ApplicationController
  load_resource
  load_and_authorize_resource

  layout Proc.new {|p| (%w(new create edit update).include?(self.action_name)) ? 'popup' : 'application' }
  before_filter :retrieve_users, :only => :index
  before_filter :find_company, :only => [:new,:create,:edit,:update]

  respond_to :json,:js,:html
  
  def index
    @search = User.new(params[:user])
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def new
    @user = @some_company.users.new
    correct_user
  end

  def create
    @user = @some_company.users.new params[:user]
    correct_user
    respond_with(@some_company) do |format|
      format.js do
        render :update do |page|
          if @user.valid? && @some_company.save          
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyUserCreate', {:user_fullname => @user.user_fullname,
              :company_id => @some_company.id}.update(@user.attributes).to_json
          else
            page.call '$("#user_submit").button','reset'
            page.call "$('#user_form').replaceWith", render(:template => 'users/new')
          end          
        end
      end
      format.any {render :nothing => true}
    end
  end

  def edit
    if @some_company.class == Agent 
      @company_url = agent_user_path(@some_company.id)
    else
      @company_url = company_user_path(@some_company.id)
    end
    render :new
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation) 
    end
    if @some_company.class == Agent 
      @company_url = agent_user_path(@some_company.id)
    else
      @company_url = company_user_path(@some_company.id)
    end
    respond_with(@user) do |format|
      format.js do
        render :update do |page|
          if @user.update_attributes params[:user]
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyUserUpdate', {:user_fullname => @user.user_fullname,
              :company_id => @some_company.id}.update(@user.attributes).to_json
            Mailer.user_updated(@user).deliver if params[:notify] == 'true'
          else
            page.call '$("#user_submit").button','reset'
            page.call "$('#user_form').replaceWith", render(:template => 'users/new')
          end          
        end
      end
      format.any {render :nothing => true}
    end
  end
  
  def batch_delete
    User.destroy_all(:id => params[:ids].split(','))
    redirect_to request.referrer || companies_path
  end
  
protected

  def correct_user
    if @some_company.class == Agent 
      @company_url = agent_users_path(@some_company.id)
    else
      @company_url = company_users_path(@some_company.id)
    end      
    @user.role_id = params[:role_id] unless @user.role_id rescue nil
  end
  
  def find_company
    @some_company = Company.find(params[:company_id]) unless params[:company_id].nil?    
    @some_company = Agent.find(params[:agent_id]) unless params[:agent_id].nil?
  end

  def retrieve_users
  	params[:role] = 'freight_forwarders' unless Role::ROLES.include? params[:role].try(:singularize)
    @users = User.send(params[:role]).page(params[:page]).per(20)
  end

end
