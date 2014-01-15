class SubsectionDatum < ActiveRecord::Base
  belongs_to :section_datum, inverse_of: :subsection_data

  attr_accessible :name,
                  :translations_attributes

  translates :name

  validates  :name,               uniqueness: { scope: :section_datum_id },
                                  presence: true
  validates :section_datum,       presence: true

  accepts_nested_attributes_for :translations,        allow_destroy: true

end