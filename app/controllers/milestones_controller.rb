class MilestonesController < ApplicationController
  load_resource
  
  def create
    @milestone = Milestone.create(params[:milestone])
    redirect_to @milestone.shipment
  end
end
