# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :license do
    maximum_clinics 1
    maximum_users 1
    first_name "FirstName"
    last_name "LastName"
    email "jsida@aasdas.com"
    phone "123321-3213123"
  end
end
