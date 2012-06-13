class MilestonesController < ApplicationController  
	layout Proc.new {|p| (%w(new create).include?(self.action_name)) ? 'popup' : 'application' }
  load_resource
  load_and_authorize_resource :except => [:get_companies]

  respond_to :html, :json

  def new
  	shipment = Shipment.find(params[:shipment_id])  	
  	@milestone = shipment.milestones.new
  end

  def create
  	shipment = Shipment.find(params[:shipment_id])
    milestone = shipment.milestones.new(params[:milestone])

    respond_to do |format|
    	if milestone.save
    		format.html { redirect_to shipment_path(shipment), :notice => 'messages.notice.milestone_created_ok' }  
    		format.js do
    			render :update do |page|
    				page.call "parent.$.fn.colorbox.close"
            page.call 'notifyCreate', milestone.to_json
    			end
    		end
    	else
    		format.html { redirect_to shipment_path(shipment) }  
    		format.js do
    			render :update do |page|
 						page.call "parent.$.fn.colorbox.close"
            page.call 'notifyError', milestone.errors.full_messages.join(', ')
	      	end
    		end
    	end
    end
  end
end