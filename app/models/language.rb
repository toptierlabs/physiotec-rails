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

  def display_name
    self.description
  end

end
