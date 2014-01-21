class SectionDatum < ActiveRecord::Base

  include AssignableHelper

  belongs_to :api_license
  belongs_to :context, polymorphic:  true
  has_many   :subsection_data,       dependent:  :destroy,
                                     inverse_of: :section_datum

  attr_accessible :name,
                  :context_type,
                  :context_id,
                  :translations_attributes,
                  :subsection_data_attributes

  translates :name
  default_scope includes(:translations)

  validates  :name,               uniqueness: { scope: :category_id },
                                  presence: true
  validates  :api_license_id,
             :context,            presence: true

  accepts_nested_attributes_for :translations,    allow_destroy: true
  accepts_nested_attributes_for :subsection_data, allow_destroy: true


end