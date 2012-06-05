# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    user_id 1
    type "MyString"
    shipment_id "MyString"
    email "MyString"
  end
end
