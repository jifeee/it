class Damage < ActiveRecord::Base
  belongs_to :milestone

  mount_uploader :photo, PhotoUploader

  after_destroy :delete_files

protected

	def delete_files
		remove_photo!
		`rm #{File.dirname(self.photo.current_path)} -rf`
	rescue
		puts ">> ERROR: File was not deleted"
	end

  
end
