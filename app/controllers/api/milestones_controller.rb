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
    
    @milestone.damages.create(:photo => params[:photo]) if params[:photo].present?
    @milestone.milestone_documents.create(:name => params[:document], :doc_type => params[:type]) if params[:document].present?
    
    if @milestone.update_attributes attrs
      render :nothing => true
    else
      render :status => 401, :json => { :errors => @milestone.errors.full_messages }
    end
  rescue => e
    render :status => 402, :json => { :errors => e.message }
  end
  
  def complete
    if @milestone.update_attributes :completed => true
      render :nothing => true
    else
      render :status => 400, :json => { :errors => @milestone.errors.full_messages }
    end
  end
  
  protected
 
  def get_milestone
    @milestone = current_user.current_milestone
  end
end
