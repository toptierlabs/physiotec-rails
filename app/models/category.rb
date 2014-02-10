# == Schema Information
#
# Table name: categories
#
#  id           :integer          not null, primary key
#  owner_id     :integer
#  context_id   :integer          not null
#  context_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Category < ActiveRecord::Base

  include Assignable

  default_scope includes(:translations)

	belongs_to :owner,                           class_name: "User"
  belongs_to :context,                         polymorphic: true

  has_many   :sections,     inverse_of: :category,
                            dependent:  :destroy
  has_many   :section_data, through: :sections

  attr_accessible :name,
                  :context_type,
                  :context_id,
                  :section_datum_ids,
                  :translations_attributes,
                  :sections_attributes

  translates :name
  
  validates :name,            presence: true
  validates :context_type,    presence: true
  validates :context_id,      presence: true
  validates :owner_id,        presence: true

  accepts_nested_attributes_for :translations,    allow_destroy: true
  accepts_nested_attributes_for :sections,    allow_destroy: true

  def self.by_user(user)
    #get user context
    #get permission for read exercises
    user_scope = :api_license
    result = case user_scope
    when :api_license
      #return all exercises

      where api_license_id: [user.api_license.id, nil]
    when :license
      #return exercises inside user license and its clinics

      licenses = user.contexts(only: :license)
                     .map(&:id)
      clinics = user.contexts(only: :clinic)
                    .map(&:id)
      where(
            api_license_id: [user.api_license.id, nil],
            context_type:   License.name,
            context_id:     licenses,
            context_type:   Clinic.name,
            context_id:     clinics
          )

    when :clinic
      #return exercises inside user clinics

      clinics = user.contexts(only: :clinic)
                    .map(&:id)

      where api_license_id: [user.api_license.id, nil],
            context_type:   Clinic.name,
            context_id:     clinics
    when :own
      #return only user's exercises

      where owner_id: user.id
    end
    result
  end

  def as_json(options={})
    aux = super(options).except(:name)
    aux[:translations] = self.translations.as_json(except:[:category_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

end
