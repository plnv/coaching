FactoryGirl.define do
  factory :user do |u|
    u.sequence(:name) { |n| "Michael Hartl#{n}" }
    u.sequence(:email) { |n| "michael#{n}@example.com" }
    u.password "foobar"
    u.password_confirmation { |u| u.password }
    factory :admin do
      admin true
    end
  end
end