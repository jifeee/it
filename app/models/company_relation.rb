class CompanyRelation < ActiveRecord::Base
  	belongs_to :company
	belongs_to :agent
  
  	validates :agent_id, :uniqueness => {:scope => :company_id}
end
