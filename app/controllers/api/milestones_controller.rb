class Api::MilestonesController < Api::ApiController
  before_filter :get_milestone
  
  def new
    render :status => 200, :nothing => true
  end
  
  def update        
    attrs = {}
    attrs.merge! :action => params[:driver_action] unless params[:driver_action].blank?
    attrs.merge! :damaged => true, :damage_desc => params[:damage] if params[:damage].present?        
    attrs.merge! :doc_type => params[:type], :doc => params[:document] if params[:document].present?
    
    attrs.merge! :latitude => params[:lat] unless params[:lat].blank?
    attrs.merge! :longitude => params[:lon] unless params[:lon].blank?
    
    @milestone.damages.create(:photo => params[:photo]) if params[:photo].present?
    
    if @milestone.update_attributes attrs
      render :nothing => true
    else
      render :status => 400, :json => { :errors => @milestone.errors.full_messages }
    end
  end
  
  def complete
    if @milestone.update_attributes :completed => true
      render :nothing => true
    else
      # render :status => 400, :json => {:errors => @milestone.errors.full_messages}
      render :status => 400, :json => {:errors => "Errors with milestone 123"}
    end
  end
  
  protected
 
  def get_milestone
    @milestone = current_user.current_milestone
  end
end
