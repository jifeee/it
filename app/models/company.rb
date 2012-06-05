class Company < ActiveRecord::Base
  has_many :company_relations
  has_many :agents, :through => :company_relations

  has_many  :user_relations, :as => :owner
  has_many  :users, :through => :user_relations

  attr_accessor :query
  
  scope :search, lambda {|params|
    where(["name LIKE ?", "%#{params['name']}%"]) if params && params['name'].present?
  }

  def full_address
    [self.zip, self.address, self.city].compact.join(',') rescue nil
  end

  def name
    "#{self['name']} (FF)"
  end

end
