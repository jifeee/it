class AddUserFields < ActiveRecord::Migration
  def self.up
    change_table :users do |t| 
      t.string :phone
      t.string :name
      t.references :company
    end
  end

  def self.down
    remove_column :users, :phone
    remove_column :users, :company_id
  end
end
