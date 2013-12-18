# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    api_license ApiLicense.find_by_name('API test name')
    context ApiLicense.find_by_name('API test name')
    title "MyString"
    description "MyString"
    association :owner, factory: :user
  end
end
