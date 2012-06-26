class Company < ActiveRecord::Base
  has_many :company_relations
  has_many :agents, :through => :company_relations

  has_many  :user_relations, :as => :owner, :dependent => :destroy
  has_many  :users, :through => :user_relations

  attr_accessor :query

  validates :name, :uniqueness => {:case_sensitive => false}
  validates :name, :address, :city, :zip, :phone, :presence => true, :length => {:maximum => 255}
  
  scope :search, lambda {|params|
    where(["name LIKE ?", "%#{params['name']}%"]) if params && params['name'].present?
  }

  def full_address
    [self.zip, self.address, self.city].compact.join(', ') rescue nil
  end

  def full_phone
    self.ext.blank? ? "#{self['phone']}" : "#{self['phone']} (ext. #{self['ext']})"
  end

  def name_with_prefix
    "#{self['name']} (FF)"
  end

  def relation_objects
    self.agents    
  end

  def relation_object_name
    I18n::t(:header_freight_agent)
  end

  def alias
    I18n::t(:header_freight_forwarder)
  end

  def allowed?
    return false if User::current.nil?
    User::current.sa? || (User::current.owner.id == self.id.to_i)
  end


end
