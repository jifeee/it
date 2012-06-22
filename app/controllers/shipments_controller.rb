class ShipmentsController < ApplicationController
  load_resource
  load_and_authorize_resource
  
  def index
    @shipments = Shipment.search(params[:shipment]).page(params[:page]).per(20)
    @search = Shipment.new(params[:shipment]) 
  end

  def show
    unless current_user && current_user.sa?
      redirect_to shipments_path if (current_user && !Shipment::allowed_shipments.include?(params[:id].to_i))
    end
  end

  def upload_edi
   	upload = params[:file_edi]
    if upload
     	parser = Parser.new(:data => upload.read)
     	unless parser.errors.any?
     		flash[:notice] = "<b>#{t('messages.upload_edi.header')}</b><p>#{t('messages.upload_edi.notice')}</p>"
     	else
     		flash[:error] = "<b>#{t('messages.upload_edi.header')}</b><p>#{parser.errors.map {|e| e[:full_message]}.join('<br />')}</p>" 
     	end
    else
      flash[:error] = "<b>#{t('messages.upload_edi.header')}</b><p>#{t('errors.messages.file_was_not_found')}</p>" 
    end
  	redirect_to shipments_path
  end

end
