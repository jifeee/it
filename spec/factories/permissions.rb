FactoryGirl.define do
  factory :permission do
    action "create"
    subject_class "User"
    conditions ""
  end
end
