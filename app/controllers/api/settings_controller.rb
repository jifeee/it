class Api::SettingsController < Api::ApiController
  def show
    render :json => current_user.to_json(:only => setting_columns)
  end
  
  def update    
    setting_columns.each do |e|
      current_user.send("#{e}=", params[e]) unless params[e].blank?
    end

    if current_user.save
      render :status => 200, :nothing => true
    else
      render :status => 400, :json => {:errors => current_user.errors.full_messages}.to_json
    end
  end
  
  private
  def setting_columns
    [:name, :email, :language, :address]
  end
end
