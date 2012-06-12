+ POST  /api/activation
  RestClient.post 'http://localhost:3001/api/activation', :code => '12345'

+ GET   /api/login
  RestClient.get('http://localhost:3001/api/login'){|response, request, result| response }
  RestClient.get('http://localhost:3001/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }

+ GET   /api/settings
  RestClient.get('http://localhost:3001/api/settings'){|response, request, result| response }
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:token => '123'}}
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:token => 'NA5LwCPEV8gBQD6qHhJE'}}

# Change application settings for the driver
+ POST  /api/settings
  RestClient.post('http://localhost:3001/api/settings', :params => ''){|response, request, result| response }
  RestClient.post 'http://localhost:3001/api/settings', :token => 'NA5LwCPEV8gBQD6qHhJE', :language => "en"

# Get shipment data by shipment ID or Cargo Code
+ POST  /api/shipment
  RestClient.post 'http://localhost:3001/api/shipment', :token => 'NA5LwCPEV8gBQD6qHhJE', :shipment_id => 1
  RestClient.post 'http://localhost:3001/api/shipment', :token => 'NA5LwCPEV8gBQD6qHhJE', :cargo => '00128138843'

# Post additional shipment info or driver action
+ POST  /api/shipment/damage (6)
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'NA5LwCPEV8gBQD6qHhJE', :driver_action => "back_at_base", :lat => "48.314934", :lon => "34.917324"
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'NA5LwCPEV8gBQD6qHhJE', :damage => "Some damage description"
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'NA5LwCPEV8gBQD6qHhJE', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'NA5LwCPEV8gBQD6qHhJE', :driver_action => "back_at_base", :damage => "Some damage description", :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Post signature data
+ POST  /api/shipment/signature (2)
  RestClient.post 'http://localhost:3001/api/shipment/signature', :token => 'NA5LwCPEV8gBQD6qHhJE', :name => "Signame", :email => "vkalion@gmail.com", :signature => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Post document (HAWB or POD)
+ POST  /api/shipment/doc (3)
  RestClient.post 'http://localhost:3001/api/shipment/doc', :token => 'NA5LwCPEV8gBQD6qHhJE', :type => "hawb", :document => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Shipment details completed
+ POST   /api/shipment/complete
  # RestClient.get 'http://localhost:3001/api/shipment/complete', {:params => {:token => 'NA5LwCPEV8gBQD6qHhJE'}}
  RestClient.get('http://localhost:3001/api/shipment/complete', :params => {:token => 'NA5LwCPEV8gBQD6qHhJE'}){|response, request, result| response }

# Start new shipment processing
+ GET   /api/shipment/new
  RestClient.get('http://localhost:3001/api/shipment/new', :params => {:token => 'NA5LwCPEV8gBQD6qHhJE'}){|response, request, result| response }





RestClient.get('http://instatrace.mobilezapp.de/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }
RestClient.post 'http://instatrace.mobilezapp.de/api/shipment', :token => 'HC4wiTjUguqX4KyF8tVZ', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')