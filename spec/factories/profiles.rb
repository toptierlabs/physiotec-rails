# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    name "MyString"

    api_license ApiLicense.find_by_name('API test name')
  end

  factory :destination_profile, class: Profile do
    name "Other profile"
    api_license ApiLicense.find_by_name('API test name')
  end
end
