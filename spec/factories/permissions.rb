# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    api_license ApiLicense.find_by_name('API test name')
  
    name "Permission name"
  end
end
