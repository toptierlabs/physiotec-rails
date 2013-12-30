# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    api_license ApiLicense.find_by_name('API test name')
    context ApiLicense.find_by_name('API test name')
    title "MyString"
    short_title "MyString"
    description "MyString"
    code "ABD3213"
    association :owner, factory: :user
  end
end
