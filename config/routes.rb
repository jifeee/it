Instatrace::Application.routes.draw do
  get "agents/index"

  get "agents/show"

  ActiveAdmin.routes(self)

  devise_for :users, :only => :registrations
  devise_for :users, ActiveAdmin::Devise.config

  resources :shipments do
    post :upload_edi, :on => :collection
  end
  resources :notifications
  resources :milestones

  resources :agents do
    resources :users
    member do
      delete :unlink_companies
      put :joincompanies
    end
    collection do
        get :get_agents
        get 'delete' => "agents#batch_delete", :as => :delete
    end
    resources :companies, :only => [] do
      member do 
        delete :unlink
      end
    end
  end

  resources :companies do
    resources :users
    member do
      delete :unlink_agents
      put :joinagents
    end
    resources :agents, :only => [] do
      member do 
        delete :unlink
      end
    end
    collection do
        get :get_companies
        get 'delete' => "companies#batch_delete", :as => :delete
    end
  end
  
  resources :users, :except => :index do
    get 'delete' => "users#batch_delete", :on => :collection, :as => :delete
  end
  
  root :to => "shipments#index"

namespace "api" do
    match '/login' => "sessions#login"
    
    post '/activation' => "api#activation"
    
    get '/settings' => "settings#show"
    post '/settings' => "settings#update"
    
    post '/shipment' => "shipments#show"
    get '/shipment/new' => "milestones#new"
    post '/shipment' => "milestones#update"
    post '/shipment/signature' => "signatures#create"
    post '/shipment/doc' => "milestones#update" 
    get '/shipment/complete' => "milestones#complete"
  end
end
