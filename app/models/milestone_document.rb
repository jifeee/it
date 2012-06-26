class MilestoneDocument < ActiveRecord::Base
	belongs_to :milestone

	DOC_TYPES = %w(hawb pod)
	mount_uploader :name, DocumentUploader

	enum_attr :doc_type, DOC_TYPES, :default => :hawb

	after_destroy :defele_files

protected

	def defele_files
		remove_name!
		`rm #{File.dirname(self.name.current_path)} -rf`
	rescue
		puts ">> ERROR: File was not deleted"
	end
end
