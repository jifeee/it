class CompanyAgent < ActiveRecord::Base
	belongs_to :company
	belongs_to :agent,
		:class_name => "company",
	 	:foreign_key => 'company_parent_id'
end
