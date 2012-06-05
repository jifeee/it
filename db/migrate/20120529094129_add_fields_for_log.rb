class AddFieldsForLog < ActiveRecord::Migration
  def self.up
  	add_column 'companies', 'created_by', :string
  	add_column 'companies', 'updated_by', :string
  	add_column 'agents', 'created_by', :string
  	add_column 'agents', 'updated_by', :string
  end

  def self.down
  	remove_column 'companies', 'created_by'
  	remove_column 'companies', 'updated_by'
  	remove_column 'agents', 'created_by'
  	remove_column 'agents', 'updated_by'
  end
end
