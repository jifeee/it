class ShipmentsController < ApplicationController
  load_and_authorize_resource :except => :show
  
  def index
    session[:user_shipment_ids] = nil
    @hawbs = Shipment.all.map &:hawb
    @shipments = Shipment.search(params[:shipment]).page(params[:page]).per(20)
    @search = Shipment.new(params[:shipment])
    session[:user_shipment_ids] = @shipments.all.map {|s| s.id.to_i}
  end

  def show
    @shipment = Shipment.find(params[:id])
    if (current_user && !current_user.sa? && !current_user.allowed_shipments.include?(params[:id].to_i)) || 
      ((current_user.nil? && session[:user_shipment_ids].nil?) || (current_user.nil? && !session[:user_shipment_ids].include?(params[:id].to_i)))
      redirect_to shipments_path 
    end
  rescue
    redirect_to root_path
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
