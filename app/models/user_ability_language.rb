class UserAbilityLanguage < ActiveRecord::Base
  belongs_to :user_ability, inverse_of: :user_ability_languages
  belongs_to :language,     inverse_of: :user_ability_languages
  belongs_to :user
  belongs_to :ability
  

  validates :user_ability, presence: true
  validates :language,     presence: true
  validates :user,         presence: true
  validates :ability,      presence: true

  validates :language_id, uniqueness: { scope: [:ability_id, :user_id] }

  before_validation :ensure_ability_and_user_are_present

  private
  	# User and ability are present on this table for
  	# validation optimization, uniqueness inside a scope
    def ensure_ability_and_user_are_present
    	self.user_id = user_ability.user.id if user_ability.present?
    	self.ability_id = user_ability.ability.id if user_ability.present?
    end

end
