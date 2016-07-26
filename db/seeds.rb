require 'factory_girl_rails'


FactoryGirl.create :admin, name: "Example User", email: "asd@asd.com"
99.times do |n|
  FactoryGirl.create :user, name: Faker::Name.name, email: "example-#{n+1}@railstutorial.org"
end
