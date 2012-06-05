class AgentsController < ApplicationController
	load_resource
  load_and_authorize_resource

	respond_to :json

	def index
		@agents = Agent.search(params[:agent]).page(params[:page]).per(20)
		@search = Agent.new(params[:agent])
	end

	def show
		@agent.query = params[:agent][:query] if params[:agent]
	end

	def create
		@agent = Agent.create params[:agent]
		redirect_to agents_path
	end

	def update
    if @agent.update_attributes(params[:agent])
      redirect_to agents_path
    else
      render :edit
    end
  end

  def unlink
  	company = Company.find_by_id(params[:company_id])
  	company.company_relations.find_by_agent_id(params[:id]).destroy
  	respond_with(company) do |format|
  		format.json do
  			render :update do |page|
  				page.call 'notifyUnlinkAgent', params[:id]
  			end
  		end
  	end    	
	end

  def get_agents
    agents = Agent.select('id, name').search('name' => params[:q]).limit(params[:limit].to_i)
    respond_with(agents) do |format|
      format.json {render :json => agents.collect {|a| {:value => a.name, :data => {:id => a.id, :obj => a}}}.to_json}
      format.any {render :nothing => true}
    end
  end

  def unlink_companies
    @agent.company_relations.where(:company_id => params[:ids].split(',')).destroy_all
    redirect_to @agent
  end

  def joincompanies
    new_companies = Company.where(:id => params[:company_ids]).all
    begin
      @agent.companies << new_companies
    rescue => e
      @agent.errors.add(:company_id, e.message)
    end
    respond_with (@agent) do |format|
      format.js do 
        render :update do |page|
          unless @agent.errors.any?
            new_companies = new_companies.map {|a| {:agents => a.agents.count,
              :agent_id => @agent.id,
              :admins => a.users.freight_forwarders.count,
              :operators => a.users.operators.count,
              :drivers => a.users.drivers.count
             }.update(a.attributes)}
            page << "$('#modal_add_companies').modal('hide');"
            page.call 'notifyJoinCompanies', new_companies.to_json
          else
            page.call 'notifyJoinCompaniesError', @agent.errors.full_messages.first
          end        
        end
      end
    end    
  end

end
