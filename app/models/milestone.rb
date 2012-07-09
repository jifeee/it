
class Milestone < ActiveRecord::Base
  include GeoHelper

  has_many :damages, :dependent => :destroy
  has_many :milestone_documents, :dependent => :destroy
  
  has_one :signature
  belongs_to :shipment
  belongs_to :driver, :class_name => 'User'
  
  enum_attr :action, %w(pick-up back_at_base en_route_to_carrier tendered_to_carrier recovered_from_carrier out_for_delivery delivery)
  
  validates :shipment_id, :driver_id, :action, :presence => {:if => :completed?}  
  validates :latitude, :longitude, :numericality => true, :presence => {:if => :completed?}  

  after_save :update_shipment, :if => :completed?
  accepts_nested_attributes_for :damages, :milestone_documents

  after_create do |record|
    record.delay.update_attribute :timezone, timeshift
  end
  
  def damaged?
    self.damaged
    # || self.damages.size > 0 || !self.damage_desc.blank?
  end

  def location?
    self.latitude && self.longitude && (self.latitude + self.longitude != 0)
  end

  def as_json(options = nil)
    hash = serializable_hash(options)
    hash[:created_at] = self.created_at.to_s
    hash[:updated_at] = self.updated_at.to_s
    hash
  end

private

  def update_shipment
    shipment.update_attribute :service_level, self.action.to_s.humanize
  end
end
