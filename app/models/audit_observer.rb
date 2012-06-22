class AuditObserver < ActiveRecord::Observer
	observe Company, Agent

	def before_update(model) 
		model['updated_by'] = Thread.current[:current_user].username rescue nil
	end

  	def before_create(model) 
  		model['created_by'] = Thread.current[:current_user].username rescue nil
  	end
end
