class Signature < ActiveRecord::Base
  belongs_to :milestone
  
  mount_uploader :signature, PhotoUploader

end
