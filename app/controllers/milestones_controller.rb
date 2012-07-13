class MilestonesController < ApplicationController  
	layout Proc.new {|p| (%w(new create).include?(self.action_name)) ? 'popup' : 'application' }
  load_resource
  load_and_authorize_resource :except => [:get_companies]

  respond_to :html, :json

  # def destroy
  #   shipment = Shipment.find(params[:shipment_id])
  #   m = Milestone.find(params[:id])    
  #   m.destroy
  #   redirect_to shipment_path(shipment)
  # end

  def new
  	shipment = Shipment.find(params[:shipment_id])  	
  	@milestone = shipment.milestones.new
  end

  def create
  	shipment = Shipment.find(params[:shipment_id])
    milestone = shipment.milestones.new(params[:milestone])

    # Fix one doc type for all documents
    milestone.milestone_documents.map {|document| document.doc_type = params[:doc_type]}

    # Fix if is_damage is not checked but damage photos or damage description present - set true
    milestone.damaged = milestone.damaged?
    
    milestone.driver_id = current_user.id if current_user.driver?
    respond_to do |format|
      if milestone.save
        milestone.update_attribute(:completed, true)
        Mailer.damage_notifier(milestone).deliver if current_user.driver? && milestone.damages && milestone.damages.size > 0
        format.html { redirect_to shipment_path(shipment.hawb), :notice => t('messages.notice.milestone_created_ok')}  
        format.js do
    			render :update do |page|
    				page.call "parent.$.fn.colorbox.close"
            response = if current_user.driver?
              {:driver => milestone.driver.username}.update(milestone.attributes).to_json 
            else
               milestone.to_json 
            end            
            page.call 'notifyCreate', response
    			end
    		end
    	else
    		format.html do
          flash[:error] = milestone.errors.full_messages.join(', ')
          redirect_to shipment_path(shipment.hawb)
        end
    		format.js do
    			render :update do |page|
            page.call 'notifyError', milestone.errors.full_messages.join(', ')
	      	end
    		end
    	end
    end
  end
end