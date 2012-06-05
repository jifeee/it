class CreateShipments < ActiveRecord::Migration
  def self.up
    create_table :shipments do |t|
      t.string :shipment_id
      t.string :cargo
      t.integer :pieces
      t.float :weight

      t.string :origin
      t.string :shipper
      t.datetime :ship

      t.string :destination
      t.string :consignee
      t.datetime :delivery
      
      t.string :service_level
      t.timestamps
    end
  end

  def self.down
    drop_table :shipments
  end
end
