# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
  	api_license
    name "MyString"
  end

  factory :destination_profile, class: Profile do
  	api_license
    name "Other profile"
  end
end
