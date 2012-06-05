class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :driver_id
      t.integer :shipment_id
      t.string :action
      t.string :location
      
      t.boolean :damaged
      t.text :damage_desc

      t.boolean :completed
      t.boolean :public
      
      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
