class CreateUserRelations < ActiveRecord::Migration
  def self.up
    create_table :user_relations do |t|
		t.integer		:user_id, :null => false
		t.references	:owner, :polymorphic => true, :null => false

		t.timestamps
    end
  end

  def self.down
    drop_table :user_relations
  end
end
