FactoryGirl.define do
  factory :admin, class: User do
    sequence(:email) { |n| "admin#{n}@runnity.com" }
    password 'runnity'
    first_name "#{Faker::Name.name}"
    last_name "#{Faker::Name.name}"
    confirm_at {Time.now}
    is_admin true
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@runnity.com" }
    password 'runnity'
    firstname "#{Faker::Name.name}"
    lastname "#{Faker::Name.name}"
    confirmed_at {Time.now}
  end
end
