FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "atar#{n}@isd.dp.ua"}
    login {|u| u.email[/^[^@]*/]}
    password 'qwe123'
    password_confirmation {|u| u.password}
    association :role
  end
end
