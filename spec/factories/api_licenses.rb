# == Schema Information
#
# Table name: api_licenses
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  public_api_key :string(255)
#  secret_api_key :string(255)
#

FactoryGirl.define do 
  sequence :api_name do |n|
    "API_License_Name_#{n}"
  end

  factory :api_license do
    name "API test name" # { FactoryGirl.generate(:api_name) }
    description "Desc" 
  end 
end 
