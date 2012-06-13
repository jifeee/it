Instatrace::Application.routes.draw do
  filter :locale,    :exclude => /^\/admin|^\/api/

  get "agents/index"
  get "agents/show"  
  match 'language/:language' => 'application#set_locale', :as => :language

  ActiveAdmin.routes(self)

  devise_for :users, :only => :registrations
  devise_for :users, ActiveAdmin::Devise.config

  resources :shipments do
    resources :milestones
    post :upload_edi, :on => :collection
  end
  resources :notifications
  resources :milestones

  resources :agents do
    resources :users
    member do
      delete :unlinks
      put :join, :action => 'join'
      get :join, :action => 'joins'
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
      delete :unlinks
      put :join, :action => 'join'
      get :join, :action => 'joins'
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
    post '/shipment/damage' => "milestones#update"
    post '/shipment/signature' => "signatures#create"
    post '/shipment/doc' => "milestones#update" 
    post '/shipment/complete' => "milestones#complete"
  end

   match '*path' => "shipments#index"
end
