class CreateAgents < ActiveRecord::Migration
  def self.up
    create_table :agents do |t|
		t.string   "name"
		t.string   "address"
		t.string   "city"
		t.string   "phone"
		t.string   "ext"
		t.string   "zip"
		t.datetime "created_at"
		t.datetime "updated_at"
		
      	t.timestamps
    end
  end

  def self.down
    drop_table :agents
  end
end
