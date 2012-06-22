ActiveAdmin.register Agent, :as => "Agents" do

  controller do
    def create
      agent = Agent.new(params[:agent])
      if agent.save
        agent.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
      end
      redirect_to [:admin, agent]
    end    

    def update
      agent = Agent.find(params[:id])
      if agent.update_attributes(params[:agent])
        agent.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
      end
      redirect_to [:admin, agent]
    end
  end

  # form for new/edit actions
  form :partial => "/active_admin/agents/form"

end
