# == Schema Information
#
# Table name: user_abilities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ability_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserAbility < ActiveRecord::Base

  require 'concerns/ability_assignable'
	include AbilityAssignable
	
  # belongs_to :user,      inverse_of: :user_abilities
  # belongs_to :ability,   inverse_of: :user_abilities

  # validates :user,       presence: true
  # validates :ability,    presence: true
  # validates :scope,      presence: true

  # validates :scope,      uniqueness: { scope: [:user_id, :ability_id] }

  # def scope
  #   @scope ||= Scope.new scope_id: self[:scope]
  # end

end
