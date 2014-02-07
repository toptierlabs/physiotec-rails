# == Schema Information
#
# Table name: permissions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  model_name       :string(255)
#  minimum_scope_id :integer
#  maximum_scope_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :permission do
    api_license ApiLicense.find_by_name('API test name')
  
    name "Permission name"
  end
end
