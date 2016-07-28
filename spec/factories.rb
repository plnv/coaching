FactoryGirl.define do
  factory :user do |u|
    u.name { Faker::Name.name }
    u.sequence(:email) { |n| "example-#{n+1}@railstutorial.org" }
    u.password "foobar"
    u.password_confirmation { |u| u.password }
    factory :admin do
      admin true
    end
  end
end