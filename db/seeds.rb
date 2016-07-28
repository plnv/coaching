require 'factory_girl_rails'


FactoryGirl.create :admin, name: "Example User", email: "asd@asd.com", password: "asdasd"
FactoryGirl.create_list :user, 99
