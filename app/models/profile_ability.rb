# == Schema Information
#
# Table name: profile_abilities
#
#  id         :integer          not null, primary key
#  profile_id :integer
#  ability_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProfileAbility < ActiveRecord::Base

  require 'concerns/ability_assignable'
  include AbilityAssignable

end
