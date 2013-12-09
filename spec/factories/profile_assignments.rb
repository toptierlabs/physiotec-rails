# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_assignment do
    profile 
    association :destination_profile
  end
end
