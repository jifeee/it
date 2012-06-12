class Api::SignaturesController < Api::MilestonesController
 
  def create    
    signature = Signature.new :signature => params[:signature], :name => params[:name], :email => params[:email]
    signature.milestone = @milestone
    
    if signature.save
      render :status => 200, :nothing => true
    else
      render :status => 400, :json => { :errors => signature.errors.full_messages }.to_json
    end
  end
  
end
