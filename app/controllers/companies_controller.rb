class CompaniesController < ApplicationController
  layout Proc.new {|p| (%w(new create edit update destroy join joins).include?(self.action_name)) ? 'popup' : 'application' }

  load_resource
  load_and_authorize_resource :except => [:get_companies]

  respond_to :json,:html,:js

  def show
    # redirect_to current_user.owner unless @company.allowed?
    @company.query = params[:company][:query] if params[:company]
  end

  def index
    @companies = Company.search(params[:company]).page(params[:page]).per(20)
    @search = Company.new(params[:company])
  end
  
  def create
    @company = Company.new params[:company]
    respond_with(@company) do |format|
      format.js do
        render :update do |page|
          if @company.save
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyCreate', {:agents => 0, :admins => 0, :operators => 0, :drivers => 0}.update(@company.attributes).to_json
          else
            page.call '$("#company_submit").button','reset'
            page.call "$('#new_company').replaceWith", render(:template => 'companies/new')
          end          
        end
      end
      format.any {render :nothing => true}
    end
  end
  
  def update
    respond_with(@company) do |format|
      format.js do
        render :update do |page|
          if @company.update_attributes(params[:company])
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyUpdate', {
              :agents => @company.agents.count,
              :admins => @company.users.admins.count,
              :operators => @company.users.operators.count, 
              :drivers => @company.users.drivers.count}.update(@company.attributes).to_json
          else
            page.call '$("#company_submit").button','reset'
            page.call "$('#edit_company_#{@company.id}').replaceWith", render(:template => 'companies/edit')
          end          
        end
      end
      format.any {render :nothing => true}
    end
  end
  
  def batch_delete
    Company.destroy_all(:id => params[:ids].split(','))
    redirect_to companies_path
  end

  def unlink
    @company.company_relations.find_by_agent_id(params[:agent_id]).destroy
    respond_with(@company) do |format|
      format.js do
        render :update do |page|
          page.call 'notifyUnlinkAgent', params[:agent_id]
        end
      end
    end     
  end

  def unlinks
    @company.company_relations.where(:agent_id => params[:ids].split(',')).destroy_all
    redirect_to @company    
  end

  def join
    new_agents = Agent.where(:id => params[:agent_ids]).all
    begin
      @company.agents << new_agents
    rescue => e
      @company.errors.add(:company_id, e.message)
    end
    respond_with (@company) do |format|
      format.js do 
        render :update do |page|
          unless @company.errors.any?
            new_agents = new_agents.map {|a| {:ffs => a.companies.count,
              :company_id => @company.id,
              :admins => a.users.admins.count,
              :operators => a.users.operators.count,
              :drivers => a.users.drivers.count
             }.update(a.attributes)}
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyJoinAgents', new_agents.to_json
          else
            page.call '$("#company_submit").button','reset'
            page.call 'notifyJoinAgentsError', @company.errors.full_messages.first
          end        
        end
      end
    end
  end

  def get_companies
    companies = Company.select('id, name')
    if params[:agent_id]
      cr = CompanyRelation.where(:agent_id => params[:agent_id])
      ids = cr.map &:company_id
      companies = companies.where(['id not in (?)',ids]) if ids.size > 0
    end
    respond_with(companies) do |format|
      format.json {render :json => companies.collect {|a| {:value => a.name, :data => {:id => a.id, :obj => a}}}.to_json}
      format.any {render :nothing => true}
    end    
  end

end
