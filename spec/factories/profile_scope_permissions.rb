# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_scope_permission do
    profile
    scope_permission
  end
end
