# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "Group_#{n}"
  end

  factory :scope_group do
    name 
    description "The description of my scope group"

    api_license ApiLicense.find_by_name('API test name')
  end

end
