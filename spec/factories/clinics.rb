# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :clinic_name do |n|
    "clinic_name_#{n}"
  end


  factory :clinic do
    name { FactoryGirl.generate(:clinic_name) }
    license
  end
end
