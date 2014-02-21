# == Schema Information
#
# Table name: exercises
#
#  id                 :integer          not null, primary key
#  subsection_id      :integer
#  exercise_medium_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise_medium do
    api_license ApiLicense.find_by_name('API test name')
    context ApiLicense.find_by_name('API test name')
    title "MyString"
    short_title "MyString"
    description "MyString"
    code "ABD3213"
    association :owner, factory: :user
  end
end
