class CargoValidator < ActiveModel::EachValidator
  # cargo should be a valid cargo number
  def validate_each(record, att, value)
    record.errors[att] << 'is invalid' unless (value =~ /^\d{11}$/) && ((value[3..-2].to_i%7).to_s == value[-1])
  end
end

class Shipment < ActiveRecord::Base
  include ActiveModel::Validations
  has_many :milestones

  validates :hawb, :presence => true, :uniqueness => {:case_sensitive => false}
  

  scope :none, where('1=2')

  scope :search, lambda {|params|
    params ||= {}
    chain = self.scoped
   
    #  Scope for simple search    
    if params['query'].present? && !params['search_type'].blank?
      chain = chain.where(params['search_type'] => params['query']) 
    elsif !params['service_level'].nil?    
    #  Scope for advanced search
      if params['service_level'] == 'open'
        chain = chain.where(:service_level != 'delivered')
      elsif params['service_level'].present?
        chain = chain.where(:service_level => params['service_level'])
      end
      %w[hawb mawb origin destination consignee shipper].each do |arg|
        chain = chain.where(arg => params[arg]) if params[arg].present?
      end
    elsif User::current && (User::current.operator? || User::current.driver? || User::current.admin?)
      chain = chain.where(:id => User::current.allowed_shipments)
    elsif User::current.nil?
      chain = chain.none
    end

    chain
  }
  
  attr_accessor :search_type, :query
  
  # validates :mawb, :cargo => true, :allow_blank => true
  # validates :hawb, :cargo => true, :allow_blank => true
  
  before_validation do |record|
    record.mawb.gsub!(/\D/, '') if record.mawb
    record.hawb.gsub!(/\D/, '') if record.hawb
  end
  
  def self.data
    Rails.cache.write(:shipment_spec, YAML::load(File.open(File.join(Rails.root, "lib", "parser", "cargo_spec.yml")))) unless Rails.cache.read(:shipment_spec)
    Rails.cache.read(:shipment_spec)
  end
  
  def self.api_search(cargo)
    return nil if cargo.nil?
    return self.where("hawb = :cargo OR mawb = :cargo", {:cargo => cargo.to_i}).first
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
      :damaged => damaged?,
      :hawb => hawb,
      :mawb => hawb
    }
  end

end

