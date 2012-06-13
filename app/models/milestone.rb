class Milestone < ActiveRecord::Base
  has_many :damages
  has_many :milestone_documents
  
  has_one :signature
  belongs_to :shipment
  belongs_to :driver, :class_name => 'User'
  
  enum_attr :action, %w(pick-up back_at_base en_route_to_carrier tendered_to_carrier recovered_from_carrier out_for_delivery delivery)
  enum_attr :doc_type, %w(hawb pod), :default => :hawb

  mount_uploader :doc, PhotoUploader
  
  validates :shipment_id, :driver_id, :action, :presence => {:if => :completed?}  
  validates :latitude, :longitude, :numericality => true

  after_save :update_shipment, :if => :completed?
  accepts_nested_attributes_for :damages, :milestone_documents
  
  private
  def update_shipment
    shipment.update_attribute :service_level, self.action.to_s.humanize
  end
end
