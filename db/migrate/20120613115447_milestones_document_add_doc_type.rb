class MilestonesDocumentAddDocType < ActiveRecord::Migration
  def self.up
	add_column 'milestone_documents', :doc_type, :string
	remove_column 'milestones', :doc_type
	remove_column 'milestones', :doc
  end

  def self.down
  	remove_column 'milestone_documents', :doc_type
  	add_column :milestones, :doc_type, :string
	add_column :milestones, :doc, :string
  end
end
