# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    title "MyString"
    description "MyString"
    owner nil
    association :context, factory: :clinic
  end
end
