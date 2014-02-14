# == Schema Information
#
# Table name: languages
#
#  id             :integer          not null, primary key
#  api_license_id :integer
#  locale         :string(255)
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Language < ActiveRecord::Base

  scope :on_api_license, ->(api_license) { where("api_license_id = ? OR api_license_id IS NULL", api_license.id) }

  has_many :user_ability_languages,    inverse_of: :language,
                                       dependent:  :destroy

  has_many :profile_ability_languages, inverse_of: :language,
                                       dependent:  :destroy

  belongs_to :api_license
  attr_accessible :description, :locale

  validates :description, :locale, presence: true
  validates :locale, uniqueness: { scope: :api_license_id }

  after_create :set_language_action
  after_create :add_to_I18n_available_locales

  def name
    self.description
  end

  private

    def set_language_action
      Action.create_by_language(self)
    end

    def add_to_I18n_available_locales
      I18n.available_locales << self.locale.to_sym
    end

end
