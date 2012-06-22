ActiveAdmin.register Company do

  controller do
    def create
      company = Company.new(params[:id])
      if company.save
        company.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
      end
      redirect_to [:admin, company]
    end    

    def update
      company = Company.find(params[:id])
      if company.update_attributes(params[:company])
        company.user_relations.create :user_id => params[:user][:user_id] unless params[:user][:user_id].blank?
      end
      redirect_to [:admin, company]
    end
  end

	# form for new/edit actions
  form :partial => "/active_admin/companies/form"

end
