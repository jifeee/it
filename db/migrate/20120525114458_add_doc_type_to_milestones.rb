class AddDocTypeToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :doc_type, :string
  end

  def self.down
    remove_column :milestones, :doc_type
  end
end
