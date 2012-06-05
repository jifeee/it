class MilestoneDocument < ActiveRecord::Base
	belongs_to :milestone

	mount_uploader :name, DocumentUploader
end
