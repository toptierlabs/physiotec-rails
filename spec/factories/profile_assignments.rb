# == Schema Information
#
# Table name: profile_assignments
#
#  id                     :integer          not null, primary key
#  profile_id             :integer
#  destination_profile_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile_assignment do
    profile 
    association :destination_profile
  end
end
