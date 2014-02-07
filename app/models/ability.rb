# == Schema Information
#
# Table name: abilities
#
#  id            :integer          not null, primary key
#  permission_id :integer
#  action_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Ability < ActiveRecord::Base

  has_many :user_abilities,    inverse_of: :ability
  has_many :profile_abilities, inverse_of: :ability

  belongs_to :permission#,   inverse_of: :permissions

  validates :permission,    presence: true
  validates :action_id,     presence: true
  validates :permission_id, uniqueness: { scope: :action_id }

  validate :translation_action

  attr_accessible :action_id,
                  :permission_id

  private

    def translation_action # validator
      if Action.find_by_id(action_id).is_translate? && !permission.is_translatable?
        errors.add :section, "permission is not translatable"
      end
    end

end
