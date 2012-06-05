class ShipmentsController < ApplicationController
  load_resource
  load_and_authorize_resource
  
  def index
    @shipments = Shipment.search(params[:shipment]).page(params[:page]).per(20)
    @search = Shipment.new(params[:shipment])
  end

  def upload_edi
   	upload = params[:file_edi]
   	parser = Parser.new(:data => upload.read)
   	unless parser.errors.any?
   		flash[:notice] = "<b>Upload file EDI</b><p>File was uploaded successfully</p>"
   	else
   		flash[:error] = "<b>Upload file EDI</b><p>#{parser.errors.map {|e| e[:full_message]}.join('<br />')}</p>" 
   	end
  	redirect_to shipments_path
  end

end
