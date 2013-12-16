# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    api_license
    title "MyString"
    description "MyString"
    owner nil
    association :context, factory: :clinic
  end
end
