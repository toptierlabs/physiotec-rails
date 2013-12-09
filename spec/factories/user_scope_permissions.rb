# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_scope_permission do
    user 
    scope_permission
  end
end
