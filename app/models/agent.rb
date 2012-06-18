class Agent < ActiveRecord::Base  
	has_many :company_relations
	has_many :companies, :through => :company_relations

	has_many  :user_relations, :as => :owner
	has_many  :users, :through => :user_relations

	attr_accessor :query

	has_many :company_relations

	validates :name, :presence => true, :uniqueness => true

	scope :search, lambda {|params|
		where(["name LIKE ?", "%#{params['name']}%"]) if params && params['name'].present?
	}

	def full_address
		[self.zip, self.address, self.city].compact.join(',') rescue nil
	end

	def name_with_prefix
    	"#{self['name']} (AGT)"
  	end

  	def relation_objects
    	self.companies
  	end

  	def relation_object_name
    	I18n::t(:header_freight_forwarder)
  	end

  	def alias
    	I18n::t(:header_freight_agent)
  	end
  		
end
