class CreateMilestoneDocuments < ActiveRecord::Migration
  def self.up
    create_table :milestone_documents do |t|
    	t.belongs_to	:milestone, :null => false
    	t.string			:name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :milestone_documents
  end
end
