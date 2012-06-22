# Admin pages for users
ActiveAdmin.register User do

  menu :if => proc{ can?(:update, User) }
  controller.authorize_resource
  controller do
    def scoped_collection
      current_user.sa? ? User.scoped : current_user.users
    end
  end
  
  
  # table for index action
  index do
    column :email
    column :login
    column :language
    column :role, :sortable => :role_id
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  # table for show action
  show :title => :email do
    attributes_table do
      row :login
      row :role
      row :language
    end
    active_admin_comments
  end

  # form for new/edit actions
  form :partial => "/active_admin/users/form"

  # available filters
  filter :login
  filter :email
  filter :language
  filter :created_at
  filter :last_sign_in_at

  # tabs to group users by roles
  scope :all, :default => true
  
  scope :sas do 
    current_user.sa? ? Role.sa.first.users : current_user.users.where(:role_id => Role.admin.first.id)
  end
  scope(:admins) do
    current_user.sa? ? Role.admin.first.users : current_user.users.where(:role_id => Role.freight_forwarder.first.id)
  end
  
  scope(:drivers) do
    current_user.sa? ? Role.driver.first.users : current_user.users.where(:role_id => Role.driver.first.id)
  end
  scope(:operators) do
    current_user.sa? ? Role.operator.first.users : current_user.users.where(:role_id => Role.operator.first.id)
  end
end

