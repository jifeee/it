class Api::ShipmentsController < Api::ApiController
  before_filter :get_shipment
  
  def show
    current_user.current_milestone.update_attributes :shipment_id => @shipment.id, :damaged => @shipment.damaged?#, :damage_desc => @shipment.damage_desc
    render :json => @shipment
  end
  
protected

  def get_shipment
	shipment_id = params[:shipment_id].to_i
	render :status => 403, :json => {:errors => "Incorect shipment number"}.to_json and return if shipment_id == 0

	@shipment = Shipment.api_search(shipment_id)
	render :status => 404, :json => {:errors => "Shipment not found"}.to_json and return unless @shipment
  end
end
