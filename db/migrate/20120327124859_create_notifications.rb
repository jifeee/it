class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :user_id
      t.string :event
      t.string :shipment_id
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
