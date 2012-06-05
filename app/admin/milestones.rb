ActiveAdmin.register Milestone do
  actions :index, :edit, :update, :show
  
  menu :if => proc{ can?(:read, Milestone) }
  controller.authorize_resource
  
  # table for index action
  index do
    column :shipment do |a|
      link_to a.shipment.shipment_id, admin_shipment_path(a.shipment) if a.shipment
    end
    column :driver
    column :action
    column :damaged
    column :public
    column "Damage desription", :damage_desc
    column "Registered", :created_at
  end

  # table for show action
  show :title => "Milestone Details" do
    attributes_table :shipment, :driver, :action, :damaged, :damage_desc
    active_admin_comments
  end
  
  # form for new/edit actions
  form do |f|
    f.inputs "Milestone Details" do
      f.input :action, :as => :select, :collection => f.object.enums(:action).map{|a| [a.to_s.humanize, a]}, :include_blank => false
      f.input :damaged
      f.input :damage_desc
    end
    f.buttons
  end
end
