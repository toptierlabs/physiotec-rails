# == Schema Information
#
# Table name: exercises
#
#  id             :integer          not null, primary key
#  context_id     :integer
#  context_type   :string(255)
#  owner_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#  code           :string(255)
#  token          :string(255)
#

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
