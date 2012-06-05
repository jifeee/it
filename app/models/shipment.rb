class CargoValidator < ActiveModel::EachValidator
  # cargo should be a valid cargo number
  def validate_each(record, att, value)
    record.errors[att] << 'is invalid' unless (value =~ /^\d{11}$/) && ((value[3..-2].to_i%7).to_s == value[-1])
  end
end

class Shipment < ActiveRecord::Base
  include ActiveModel::Validations
  has_many :milestones
  
  scope :search, lambda {|params|
    params ||= {}
    chain = self.scoped
    if params['service_level'].present?
      if params['service_level'] == 'open'
        chain = chain.where(:service_level != 'delivered')
      else
        chain = chain.where(:service_level => params['service_level'])
      end
    end
    if params['query'].present? && !params['search_type'].blank?
      chain = chain.where(params['search_type'] => params['query'])
    else
      %w[hawb mawb origin destination consignee shipper].each do |arg|
        chain = chain.where(arg => params[arg]) if params[arg].present?
      end
    end
    chain
  }
  
  attr_accessor :search_type, :query
  validates :mawb, :cargo => true, :allow_blank => true
  validates :hawb, :cargo => true, :allow_blank => true
  
  before_validation do |record|
    record.mawb.gsub!(/\D/, '') if record.mawb
    record.hawb.gsub!(/\D/, '') if record.hawb
  end
  
  def self.data
    Rails.cache.write(:shipment_spec, YAML::load(File.open(File.join(Rails.root, "lib", "parser", "cargo_spec.yml")))) unless Rails.cache.read(:shipment_spec)
    Rails.cache.read(:shipment_spec)
  end
  
  def self.api_search(shipment_id, cargo_code)
    if shipment_id.to_i > 0
      self.where("shipment_id = ?", shipment_id).first
    elsif cargo_code.present?
      cargo_code.gsub!(/\D/, '')
      self.where("hawb = :cargo OR mawb = :cargo", {:cargo => cargo_code} ).first
    else
      nil
    end
  end
  
  def damaged?
    !milestones.where(:damaged => true).count.zero?
  end

  def current_status
    self.milestones.last.action rescue ''
  end
  
  def as_json(options={})
    { :shipment_id => shipment_id,
      :pieces => pieces,
      :weight => weight,
      :pick_up => origin,
      :destination => destination,
      :damaged => damaged? }
  end
end

