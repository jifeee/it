ActiveAdmin.register Shipment do

  menu :if => proc{ can?(:update, Shipment) }
  controller.authorize_resource

  # table for index action
  index do
    column(:hawb) {|s| link_to s.hawb, admin_shipment_path(s)}
    column :service_level
    column :mawb
    column :pieces
    column("Weight") {|s| "#{s.weight} Lb." }
    column :origin
    column :destination
    column :shipper
    column :consignee
    column :ship
    column :delivery
    column "Registered", :created_at
  end

  # table for show action
  show :title => :shipment_id do
    attributes_table :shipment_id, :service_level, :hawb, :mawb, :pieces, :weight, :origin, :destination, :shipper, :consignee, :ship, :delivery
    active_admin_comments
  end
  
  # form for new/edit actions
  form do |f|
    f.inputs "Shipment Details" do
      f.input :shipment_id
      f.input :service_level
      f.input :hawb
      f.input :mawb
      f.input :pieces
      f.input :weight
      f.input :origin
      f.input :destination
      f.input :shipper
      f.input :consignee
      f.input :ship
      f.input :delivery
    end
    f.buttons
  end
end

