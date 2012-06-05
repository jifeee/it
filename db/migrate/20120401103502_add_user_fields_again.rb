class AddUserFieldsAgain < ActiveRecord::Migration
  def self.up
    change_table :users do |t| 
      t.string :last_name
      t.string :first_name
    end
  end

  def self.down
    remove_column :users, :last_name, :first_name
  end
end
