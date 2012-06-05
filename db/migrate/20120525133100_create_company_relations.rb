class CreateCompanyRelations < ActiveRecord::Migration
  def self.up
    create_table :company_relations do |t|
      t.integer :company_id, :null => false
      t.integer :agent_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :company_relations
  end
end
