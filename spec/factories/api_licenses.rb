FactoryGirl.define do 
  sequence :api_name do |n|
    "API_License_Name_#{n}"
  end

  factory :api_license do
    name { FactoryGirl.generate(:api_name) }
    description "Desc" 
  end 
end 