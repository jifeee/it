class CompanyType < ActiveRecord::Base
	has_many :companies, :dependent => :nullify
end
