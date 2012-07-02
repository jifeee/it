class ShipmentsController < ApplicationController
  # session :on
  # load_and_authorize_resource :except => :show
  
  def index
    @hawbs = Shipment.all.map &:hawb
    @shipments = Shipment.search(params[:shipment]).page(params[:page]).per(20)
    @search = Shipment.new(params[:shipment])
    cookies[:appversion] = "1.0.1" 
    session['user_shipment_ids'] = [1,2,3]
  end

  def show
    @shipment = Shipment.find_by_hawb(params[:id])
    # @shipment = Shipment.find(params[:id])
    # if (current_user && !current_user.sa? && (!current_user.allowed_shipments.include?(params[:id].to_i) || !session[:user_shipment_ids].include?(params[:id].to_i))) || 
    #   ((current_user.nil? && session[:user_shipment_ids].nil?) || (current_user.nil? && !session[:user_shipment_ids].include?(params[:id].to_i)))
    #   redirect_to shipments_path 
    # end
    # ids = session['user_shipment_ids']
    # redirect_to shipments_path, :notice => session['user_shipment_ids'].join(',') unless session['user_shipment_ids'].include?(params[:id].to_i)
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
