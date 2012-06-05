# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do |shipment|
  factory :shipment do
    hawb "74781140743"
    mawb "74781140710"
    shipment_id 1356
    pieces 1
    weight 1.5
    origin "Dallas, USA"
    destination "LA, USA"
  end
end
