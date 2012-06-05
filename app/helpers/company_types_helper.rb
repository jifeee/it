module CompanyTypesHelper
	def company_type_for_select
		CompanyType.all.collect { |s| [s.name,s.id] }    
	end
end
