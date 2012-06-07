class MilestonesController < ApplicationController  
	layout Proc.new {|p| (%w(new create).include?(self.action_name)) ? 'popup' : 'application' }
  load_resource
  load_and_authorize_resource :except => [:get_companies]

  respond_to :html, :js

  def new
  	shipment = Shipment.find(params[:shipment_id])  	
  	@milestone = shipment.milestones.new
  end

  def create
  	shipment = Shipment.find(params[:shipment_id])
    milestone = shipment.milestones.new(params[:milestone])

    respond_to do |format|
    	if milestone.save
    		format.html { redirect_to shipment_path(shipment), :notice => 'Milestone was successfully created.' }  
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
	      		redirect_to shipment_path(shipment.id), :notice => 'Milestone was successfully created.'
	      	end
    		end
    	end
    end
  end
end

# render :update, :content_type => 'text/javascript' do |page|
#           if milestone.save
#             page.call "parent.$.fn.colorbox.close"
#             # page.call 'notifyCreate', milestone.to_json
#           else
#             page.call '$("#milestone_submit").button','reset'
#             # page.call 'notifyError', milestone.errors.full_messages.first
#           end          
#         end