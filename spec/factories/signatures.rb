# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :signature do
    association :milestone, FactoryGirl(:milestone)
    name "John"
    email "Reed"
  end
end
