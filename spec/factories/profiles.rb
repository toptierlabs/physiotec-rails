# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    name "MyString"
  end

  factory :destination_profile, class: Profile do
    name "Other profile"
  end
end
