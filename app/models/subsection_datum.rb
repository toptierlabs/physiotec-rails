# == Schema Information
#
# Table name: subsection_data
#
#  id               :integer          not null, primary key
#  section_datum_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SubsectionDatum < ActiveRecord::Base

  default_scope includes(:translations)
  
  belongs_to :section_datum, inverse_of: :subsection_data

  attr_accessible :name,
                  :translations_attributes

  translates :name
  default_scope includes(:translations)

  validates  :name,               uniqueness: { scope: :section_datum_id },
                                  presence: true
  validates :section_datum,       presence: true

  accepts_nested_attributes_for :translations,        allow_destroy: true

  def as_json(options={})
    aux = super(options).except(:name)
    aux[:translations] = self.translations.as_json(except:[:subsection_datum_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

end
