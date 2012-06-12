class Api::ShipmentsController < Api::ApiController
  before_filter :get_shipment
  
  def show
    current_user.current_milestone.update_attributes :shipment_id => @shipment.id, :damaged => @shipment.damaged?#, :damage_desc => @shipment.damage_desc
    render :json => @shipment
  end
  
  protected
  def get_shipment
    @shipment = Shipment.api_search(params[:shipment_id], params[:cargo])    
    render :status => 404, :json => {:errors => "Shipment not found"}.to_json and return unless @shipment
  end
end
