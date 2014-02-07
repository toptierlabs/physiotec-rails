# == Schema Information
#
# Table name: clinics
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  license_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :clinic_name do |n|
    "clinic_name_#{n}"
  end


  factory :clinic do
    name { FactoryGirl.generate(:clinic_name) }
    license
    api_license ApiLicense.find_by_name('API test name')
    
  end
end
