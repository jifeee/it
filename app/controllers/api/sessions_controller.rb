class Api::SessionsController < ApplicationController
  def login
    user = User.create :email => params[:email],
                       :password => params[:password],
                       :password_confirmation => params[:password],
                       :name => params[:name],
                       :address => params[:address],
                       :language => params[:language]
    if user.valid?
      user.generate_token!
      render :json => {:token => user.api_token}.to_json
    else
      render :status => 403, :json => {:errors => user.errors.full_messages}.to_json
    end
  end
end
