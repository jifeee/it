class Api::MilestonesController < Api::ApiController
  before_filter :get_milestone
  
  def new
    render :status => 200, :nothing => true
  end
  
  def update        
    attrs = {}
    attrs.merge! :action => params[:driver_action] unless params[:driver_action].blank?
    attrs.merge! :damage_desc => params[:damage] if params[:damage].present?        
    attrs.merge! :damaged => params[:damaged] if params[:damaged].present?
    
    attrs.merge! :latitude => params[:lat] unless params[:lat].blank?
    attrs.merge! :longitude => params[:lon] unless params[:lon].blank?
    
    if params[:photo].present? && params[:photo].class == Array
      params[:photo].map do |photo|
        encoded_img = photo.sub('data:image/png;base64,', '')
        io = FilelessIO.new(Base64.decode64(encoded_img))
        io.original_filename = "damage_#{@milestone.shipment.hawb}.jpg"
        @milestone.damages.create(:photo => io)        
      end
    end

    @milestone.milestone_documents.create(:name => params[:document], :doc_type => params[:type]) if params[:document].present?
    
    if @milestone.update_attributes attrs
      render :nothing => true
    else
      render :status => 400, :json => { :errors => @milestone.errors.full_messages }
    end
  rescue => e
    render :status => 400, :json => { :errors => e.message }
  end

  def cancel
    if @milestone.destroy
      render :nothing => true
    else
      render :status => 400, :json => { :errors => @milestone.errors.full_messages }
    end    
  end
  
  def complete
    if @milestone.update_attributes :action => params[:driver_action], 
      :latitude => params[:latitude], :longitude => params[:longitude], :completed => true
      render :status => 200, :nothing => true
    else
      render :json => {:status => 400, :errors => @milestone.errors.full_messages }
    end
  rescue => e
    render :json => {:status => 400, :errors => e.message }
  end
  
  protected
 
  def get_milestone
    @milestone = current_user.current_milestone
  end
end
