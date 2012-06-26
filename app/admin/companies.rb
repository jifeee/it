ActiveAdmin.register Company do

  controller do
    def create
      super
      @company.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
    end    

    def update
      super
      @company.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
    end
  end

	# form for new/edit actions
  form :partial => "/active_admin/companies/form"

end
