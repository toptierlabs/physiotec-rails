# == Schema Information
#
# Table name: licenses
#
#  id              :integer          not null, primary key
#  maximum_clinics :integer
#  maximum_users   :integer
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  api_license_id  :integer
#  company_name    :string(255)
#  users_count     :integer          default(0), not null
#

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
    api_license ApiLicense.find_by_name('API test name')
  end
end


