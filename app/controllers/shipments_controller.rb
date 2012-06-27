class ShipmentsController < ApplicationController
  load_resource
  load_and_authorize_resource
  
  def index
    @hawbs = Shipment.all.map &:hawb

    if params[:shipment]
      @shipments = Shipment.search(params[:shipment]).page(params[:page]).per(20)
    elsif current_user && (User::current.operator? || User::current.driver? || User::current.admin?)
      @shipments = Shipment.where(:id => current_user.allowed_shipments).page(params[:page]).per(20)
    elsif current_user && current_user.sa?
      @shipments = Shipment.page(params[:page]).per(20)
    elsif
      @shipments = nil        
    end
    #  For signed users
    # if User::current && (User::current.operator? || User::current.driver? || User::current.admin?)
    #   @shipments = @shipments.where(:id => allowed_shipments)
    # end

    #  For unsigned users
    # chain = chain.where('0=8') if User::current.nil? && !is_search


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
