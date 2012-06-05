+ POST  /api/activation
  RestClient.post 'http://localhost:3001/api/activation', :code => 'DVyctJnG14Q5jm1EPuWr'

+ GET   /api/login
  RestClient.get('http://localhost:3001/api/login'){|response, request, result| response }
  RestClient.get('http://localhost:3001/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }

+ GET   /api/settings
  RestClient.get('http://localhost:3001/api/settings'){|response, request, result| response }
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:code => '123'}}
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:code => 'DVyctJnG14Q5jm1EPuWr'}}

# Change application settings for the driver
+ POST  /api/settings
  RestClient.post('http://localhost:3001/api/settings', :params => ''){|response, request, result| response }
  RestClient.post 'http://localhost:3001/api/settings', :code => 'DVyctJnG14Q5jm1EPuWr', :language => "en"

# Get shipment data by shipment ID or Cargo Code
+ POST  /api/shipment
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :shipment_id => 1
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :cargo => '00128138843'

# Post additional shipment info or driver action
+ POST  /api/shipment (6)
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :driver_action => "back_at_base"
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :damage => "Some damage description"
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')
  RestClient.post 'http://localhost:3001/api/shipment', :code => 'DVyctJnG14Q5jm1EPuWr', :driver_action => "back_at_base", :damage => "Some damage description", :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Post signature data
+ POST  /api/shipment/signature (2)
  RestClient.post 'http://localhost:3001/api/shipment/signature', :code => 'DVyctJnG14Q5jm1EPuWr', :name => "Signame", :email => "vkalion@gmail.com", :signature => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Post document (HAWB or POD)
+ POST  /api/shipment/doc (3)
  RestClient.post 'http://localhost:3001/api/shipment/doc', :code => 'DVyctJnG14Q5jm1EPuWr', :type => "hawb", :document => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Shipment details completed
+ GET   /api/shipment/complete
  # RestClient.get 'http://localhost:3001/api/shipment/complete', {:params => {:code => 'DVyctJnG14Q5jm1EPuWr'}}
  RestClient.get('http://localhost:3001/api/shipment/complete', :params => {:code => 'DVyctJnG14Q5jm1EPuWr'}){|response, request, result| response }

# Start new shipment processing
+ GET   /api/shipment/new
  RestClient.get('http://localhost:3001/api/shipment/new', :params => {:code => 'DVyctJnG14Q5jm1EPuWr'}){|response, request, result| response }





RestClient.get('http://instatrace.mobilezapp.de/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }
RestClient.post 'http://instatrace.mobilezapp.de/api/shipment', :code => 'HC4wiTjUguqX4KyF8tVZ', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')