class CompaniesController < ApplicationController
  load_resource
  load_and_authorize_resource

  respond_to :json

  def show
    @company.query = params[:company][:query] if params[:company]
  end

  def index
    @companies = Company.search(params[:company]).page(params[:page]).per(20)
    @search = Company.new(params[:company])
  end
  
  def create
    @company = Company.create params[:company]
    redirect_to companies_path
  end
  
  def update
    if @company.update_attributes(params[:company])
      redirect_to companies_path
    else
      render :edit
    end
  end
  
  def batch_delete
    Company.destroy_all(:id => params[:ids].split(','))
    redirect_to companies_path
  end

  def unlink
    agent = Agent.find_by_id(params[:agent_id])
    agent.company_relations.find_by_company_id(params[:id]).destroy
    respond_with(agent) do |format|
      format.json do
        render :update do |page|
          page.call 'notifyUnlinkCompany', params[:id]
        end
      end
    end     
  end

  def unlink_agents
    @company.company_relations.where(:agent_id => params[:ids].split(',')).destroy_all
    redirect_to @company    
  end

  def joinagents
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
              :admins => a.users.freight_forwarders.count,
              :operators => a.users.operators.count,
              :drivers => a.users.drivers.count
             }.update(a.attributes)}
            page << "$('#modal_add_agents').modal('hide');"
            page.call 'notifyJoinAgents', new_agents.to_json
          else
            page.call 'notifyJoinAgentsError', @company.errors.full_messages.first
          end        
        end
      end
    end
  end

  def get_companies
    companies = Company.select('id, name').search('name' => params[:q]).limit(params[:limit].to_i)
    respond_with(companies) do |format|
      format.json {render :json => companies.collect {|a| {:value => a.name, :data => {:id => a.id, :obj => a}}}.to_json}
      format.any {render :nothing => true}
    end    
  end

end
