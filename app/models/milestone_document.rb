class MilestoneDocument < ActiveRecord::Base
	belongs_to :milestone

	DOC_TYPES = %w(hawb pod)
	mount_uploader :name, DocumentUploader


	enum_attr :doc_type, DOC_TYPES, :default => :hawb
end
