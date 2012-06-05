class Damage < ActiveRecord::Base
  belongs_to :milestone

  mount_uploader :photo, PhotoUploader
  
end
