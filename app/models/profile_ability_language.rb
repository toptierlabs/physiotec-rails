# == Schema Information
#
# Table name: profile_ability_languages
#
#  id                 :integer          not null, primary key
#  profile_ability_id :integer
#  language_id        :integer
#  ability_id         :integer
#  profile_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ProfileAbilityLanguage < ActiveRecord::Base
  belongs_to :profile_ability, inverse_of: :profile_ability_languages
  belongs_to :language,        inverse_of: :profile_ability_languages
  belongs_to :profile
  belongs_to :ability
  

  validates :profile_ability, presence: true
  validates :language,        presence: true
  validates :profile,         presence: true
  validates :ability,         presence: true

  validates :language_id, uniqueness: { scope: [:ability_id, :profile_id] }

  before_validation :ensure_ability_and_profile_are_present

  private
  	# profile and ability are present on this table for
  	# validation optimization, uniqueness inside a scope
    def ensure_ability_and_profile_are_present
    	self.profile_id = profile_ability.profile.id if profile_ability.present?
    	self.ability_id = profile_ability.ability.id if profile_ability.present?
    end

end
