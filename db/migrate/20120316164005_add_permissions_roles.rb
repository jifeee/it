class AddPermissionsRoles < ActiveRecord::Migration
  def self.up
    create_table :permissions_roles, :id => false do |t| 
      t.references :role
      t.references :permission
    end
  end
end
