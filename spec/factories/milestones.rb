# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :milestone do
    driver_id 1
    action :"pick-up"
    shipment_id 1
    damaged false
    doc { File.open(File.join(Rails.root, "public", "images", 'insta_logo.png')) }
    completed true
  end
  
  factory :damaged, :parent => :milestone do
    damaged true
    damage_desc "top right corner creased"
  end
  
  factory :empty_milestone, :class => Milestone do
  end
end
