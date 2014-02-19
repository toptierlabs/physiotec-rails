# Read about factories at https://github.com/thoughtbot/factory_girl

 FactoryGirl.define do
   factory :assignment do
     user
     association :assignable, factory: :exercise_medium
   end
 end
