# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :license_email do |n|
    "license_mail_#{n}@mail.com"
  end

  factory :license do
    maximum_clinics 1
    maximum_users 1
    first_name "FirstName"
    last_name "LastName"
    email { FactoryGirl.generate(:license_email) }
    phone "123321-3213123"
    api_license
  end
end


