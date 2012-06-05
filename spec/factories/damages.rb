# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :damage do
    association :milestone, FactoryGirl(:milestone)
    photo "MyString"
  end
end
