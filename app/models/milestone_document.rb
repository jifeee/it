class MilestoneDocument < ActiveRecord::Base
	belongs_to :milestone

	mount_uploader :name, DocumentUploader
	enum_attr :doc_type, %w(hawb pod), :default => :hawb
end
