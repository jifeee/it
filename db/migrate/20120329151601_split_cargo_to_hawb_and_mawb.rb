class SplitCargoToHawbAndMawb < ActiveRecord::Migration
  def self.up
    add_column :shipments, :hawb, :string
    add_column :shipments, :mawb, :string
    
    Shipment.reset_column_information
    Shipment.all.each do |ship| 
      ship.update_attribute :hawb, ship.cargo
    end
    remove_column :shipments, :cargo
  end

  def self.down
    add_column :shipments, :cargo, :string
    
    Shipment.reset_column_information
    Shipment.each do |ship|
      ship.update_attribute :cargo, ship.hawb || ship.mawb
    end
  
    remove_column :shipments, :hawb
    remove_column :shipments, :mawb
  end
end
