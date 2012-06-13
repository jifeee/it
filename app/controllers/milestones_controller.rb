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
    milestone.driver_id = current_user.id if current_user.driver?
    respond_to do |format|
      if milestone.save
        Mailer.damage_notifier(milestone).deliver if current_user.driver? && milestone.damages && milestone.damages.size > 0
        format.html { redirect_to shipment_path(shipment), :notice => 'messages.notice.milestone_created_ok' }  
        format.js do
    			render :update do |page|
    				page.call "parent.$.fn.colorbox.close"
            page.call 'notifyCreate', {:driver => milestone.driver.username}.update(milestone.attributes).to_json
    			end
    		end
    	else
    		format.html do
          flash[:error] = milestone.errors.full_messages.join(', ')
          redirect_to shipment_path(shipment)
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