# == Schema Information
#
# Table name: profile_abilities
#
#  id         :integer          not null, primary key
#  profile_id :integer
#  ability_id :integer
#  scope_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProfileAbility < ActiveRecord::Base
  # belongs_to :profile,  inverse_of: :profile_abilities
  # belongs_to :ability,  inverse_of: :profile_abilities

  # validates :profile,   presence: true
  # validates :ability,   presence: true
  # validates :scope,     presence: true

  # validates :scope,     uniqueness: { scope: [:profile_id, :ability_id] }
  
  # def scope
  #   @scope ||= Scope.new scope_id: self[:scope]
  # end

  include AbilityAssignable

end
