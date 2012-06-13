class Api::SignaturesController < Api::MilestonesController
 
  def create    
    encoded_img = params[:signature].sub('data:image/png;base64,', '')
    
    io = FilelessIO.new(Base64.decode64(encoded_img))
    io.original_filename = "signature.png"
    
    signature = Signature.new :name => params[:name], :email => params[:email]
    signature.signature = io
    signature.milestone = @milestone
    
    if signature.save
      render :status => 200, :nothing => true
    else
      render :status => 400, :json => { :errors => signature.errors.full_messages }.to_json
    end
  end
  
end
