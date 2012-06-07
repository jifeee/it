class AgentsController < ApplicationController
  layout Proc.new {|p| (%w(new create edit update destroy join joins).include?(self.action_name)) ? 'popup' : 'application' }

	load_resource
  load_and_authorize_resource :except => [:get_agents]

	respond_to :json

	def index
		@agents = Agent.search(params[:agent]).page(params[:page]).per(20)
		@search = Agent.new(params[:agent])
	end

	def show
		@agent.query = params[:agent][:query] if params[:agent]
	end

  def create
    @agent = Agent.new params[:agent]
    respond_with(@agent) do |format|
      format.js do
        render :update do |page|
          if @agent.save
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyCreate', {:companies => 0, :admins => 0, :operators => 0, :drivers => 0}.update(@agent.attributes).to_json
          else
            page.call '$("#agent_submit").button','reset'
            page.call 'notifyError', @agent.errors.full_messages.first
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
            if @agent.update_attributes(params[:agent])
              page.call "parent.$.fn.colorbox.close"
              page.call 'notifyUpdate', {
                :companies => @agent.companies.count,
                :admins => @agent.users.freight_forwarders.count,
                :operators => @agent.users.operators.count, 
                :drivers => @agent.users.drivers.count}.update(@agent.attributes).to_json
            else
              page.call '$("#agent_submit").button','reset'
              page.call 'notifyError', @agent.errors.full_messages.first
            end          
          end
        end
        format.any {render :nothing => true}
      end    
  end

  def unlink
    @agent.company_relations.find_by_company_id(params[:company_id]).destroy
    respond_with(@agent) do |format|
      format.json do
        render :update do |page|
          page.call 'notifyUnlinkCompany', params[:company_id]
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

  def unlinks
    @agent.company_relations.where(:company_id => params[:ids].split(',')).destroy_all
    redirect_to @agent
  end

  def join
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
            page.call "parent.$.fn.colorbox.close"
            page.call 'notifyJoinCompanies', new_companies.to_json
          else
            page.call '$("#company_submit").button','reset'
            page.call 'notifyJoinCompaniesError', @agent.errors.full_messages.first
          end        
        end
      end
    end    
  end

  def batch_delete
    Agent.destroy_all(:id => params[:ids].split(','))
    redirect_to agents_path
  end

end
