+ POST  /api/activation
  RestClient.post 'http://localhost:3001/api/activation', :code => '12345'

+ GET   /api/login
  RestClient.get('http://localhost:3001/api/login'){|response, request, result| response }
  RestClient.get('http://localhost:3001/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }

+ GET   /api/settings
  RestClient.get('http://localhost:3001/api/settings'){|response, request, result| response }
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:token => '123'}}
  RestClient.get 'http://localhost:3001/api/settings', {:params => {:token => 'Lc68SuqSyxJYxzKCHyqU'}}

# Change application settings for the driver
+ POST  /api/settings
  RestClient.post('http://localhost:3001/api/settings', :params => ''){|response, request, result| response }
  RestClient.post 'http://localhost:3001/api/settings', :token => 'Lc68SuqSyxJYxzKCHyqU', :language => "en"

# Get shipment data by shipment ID or Cargo Code AND set current milestone
+ POST  /api/shipment
  RestClient.post 'http://localhost:3001/api/shipment', :token => 'Lc68SuqSyxJYxzKCHyqU', :shipment_id => 1
  RestClient.post 'http://localhost:3001/api/shipment', :token => 'Lc68SuqSyxJYxzKCHyqU', :cargo => '00128138843'

# Post additional shipment info or driver action
+ POST  /api/shipment/damage (6)
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'Lc68SuqSyxJYxzKCHyqU', :driver_action => "back_at_base", :lat => "48.314934", :lon => "34.917324"
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'Lc68SuqSyxJYxzKCHyqU', :damage => "Some damage description", :damaged => 0
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'Lc68SuqSyxJYxzKCHyqU', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')
  RestClient.post 'http://localhost:3001/api/shipment/damage', :token => 'Lc68SuqSyxJYxzKCHyqU', :driver_action => "back_at_base", :damage => "Some damage description", :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')

# Post signature data
+ POST  /api/shipment/signature (2)
  # RestClient.post 'http://localhost:3001/api/shipment/signature', :token => 'Lc68SuqSyxJYxzKCHyqU', :name => "Signame", :email => "vkalion@gmail.com", :signature => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')
  RestClient.post 'http://localhost:3001/api/shipment/signature', :token => 'Lc68SuqSyxJYxzKCHyqU', :name => "Signame", :email => "vkalion@gmail.com", :signature => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASwAAABkCAYAAAA8AQ3AAAAC+klEQVR4Ae3UgQkAIAwDQXX/nau4xcN1gnAp2fNuOQIECAQETiCjiAQIEPgCBssjECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDAYPkBAgQyAgYrU5WgBAgYLD9AgEBGwGBlqhKUAAGD5QcIEMgIGKxMVYISIGCw/AABAhkBg5WpSlACBAyWHyBAICNgsDJVCUqAgMHyAwQIZAQMVqYqQQkQMFh+gACBjIDBylQlKAECBssPECCQETBYmaoEJUDgAsEIBMQScsQXAAAAAElFTkSuQmCC"

# Post document (HAWB or POD)
+ POST  /api/shipment/doc (3)
  RestClient.post 'http://localhost:3001/api/shipment/doc', :token => 'Lc68SuqSyxJYxzKCHyqU', :type => "hawb", :document => File.new(Rails.root.to_s + "/public/robots.txt", 'rb')

# Shipment details completed
+ POST   /api/shipment/complete
  # RestClient.get 'http://localhost:3001/api/shipment/complete', {:params => {:token => 'Lc68SuqSyxJYxzKCHyqU'}}
  RestClient.post('http://localhost:3001/api/shipment/complete', :token => 'Lc68SuqSyxJYxzKCHyqU') {|response, request, result| response }
  # RestClient.get('http://localhost:3001/api/shipment/complete', :params => {:token => 'Lc68SuqSyxJYxzKCHyqU'}){|response, request, result| response }

# Start new shipment processing
+ GET   /api/shipment/new
  RestClient.get('http://localhost:3001/api/shipment/new', :params => {:token => 'Lc68SuqSyxJYxzKCHyqU'}){|response, request, result| response }





RestClient.get('http://instatrace.mobilezapp.de/api/login', {:params => {:name => 'Vadim', :address => 'Kirov pr.', :language => "en", :email => 'vkalion@gmail.com', :password => 'qwe123'}}){|response, request, result| response }
RestClient.post 'http://instatrace.mobilezapp.de/api/shipment', :token => 'HC4wiTjUguqX4KyF8tVZ', :photo => File.new(Rails.root.to_s + "/public/images/insta_logo.png", 'rb')