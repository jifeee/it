class Notification < ActiveRecord::Base
  belongs_to :user
  
  validates :email, :presence => true
  validates :shipment_id, :presence => true
  
  enum_attr :event, %w(damage delay)
end
